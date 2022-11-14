;2022.11.14 mar

begin
	filename         = (/"RAD","CLD","CTL","CLEAN"/)
	dir              = "../"
	
	;read tc center data
	TCcent           = (/"CTL_cent.txt","MICRO_cent.txt",\
	"RAD_cent.txt","CLEAN_cent.txt"/)
	nfile            = dimsizes(TCcent) 
	nrow             = numAsciiRow(TCcent(0))
	centi            = new((/nfile,nrow/), "float")
	centj            = new((/nfile,nrow/), "float")
	do i=0, nfile-1
		data    = asciiread(TCcent(i), -1, "string")
		centi(i,:)     = stringtofloat(str_get_field(data, 3, ",")) 
		centj(i,:)     = stringtofloat(str_get_field(data, 4, ",")) 
	end do
	printVarSummary(centi)
	
    f                = addfiles(dir+filename,"r")
	interp_levels    = fspan(100,14000,40)
	ncir             = 101                   
	pi               = 3.14159265
	nrad             = 360
	nx               = 399
	ny               = 399
	dx               = 3
	times            = 49
	nfile            = 3
	x_po             = new((/ncir, nrad/),float)  ;generate polar coordinate
	y_po             = x_po


	rw_out           = new((/nfile,times,dimsizes(interp_levels),ncir,nrad/),float,0)
	mw_out           = new((/nfile,times,dimsizes(interp_levels),ncir,nrad/),float,0)
	div_out          = new((/nfile,times,dimsizes(interp_levels),ncir,nrad/),float,0)
	pv_out           = new((/nfile,times,dimsizes(interp_levels),ncir,nrad/),float,0)

	rw_int           = new((/dimsizes(interp_levels),nx,ny/),float,0)
	mw_int           = new((/dimsizes(interp_levels),nx,ny/),float,0)
	div_int          = new((/dimsizes(interp_levels),nx,ny/),float,0)
	pv_int           = new((/dimsizes(interp_levels),nx,ny/),float,0)
	
do nf = 0, 2
;; acqur data
	k                = 0 
	do i=0,times-1
		w                       = wrf_user_getvar(f[nf],"wa",i)	      
        pv                      = wrf_user_getvar(f[nf],"pvo",i)	
		slp                     = wrf_user_getvar(f[nf],"slp",i)
		z                       = wrf_user_getvar(f[nf],"z",i)
		p                       = wrf_user_getvar(f[nf],"p",i)
		T                       = wrf_user_getvar(f[nf],"tk",i)
		td                      = wrf_user_getvar(f[nf],"td",i)
		u                       = wrf_user_getvar(f[nf],"ua",i)
		v                       = wrf_user_getvar(f[nf],"va",i)
		lat                     = wrf_user_getvar(f[nf],"lat",i)
		lon                     = wrf_user_getvar(f[nf],"lon",i)
		u10                     = f[nf]->U10(i,:,:)
		v10                     = f[nf]->V10(i,:,:)
		sped                    = wind_speed(u10,v10)
		lat1                    = lat(:,0)
		lon1                    = lon(0,:)
		div                     = uv2dv_cfd(u,v,lat1,lon1,0)
		rw                      = w*0.217*6.1078*exp(17.269*td/(td+273.15-35.86))/T
		mw                      = w*p/287/T
		
; interpolate
		do j=0,dimsizes(interp_levels)-1
			rw_int(j,:,:)       	= wrf_interp_3d_z(rw,z,interp_levels(j))
			mw_int(j,:,:)    		= wrf_interp_3d_z(mw,z,interp_levels(j))
			div_int(j,:,:)     		= wrf_interp_3d_z(div,z,interp_levels(j))
			pv_int(j,:,:)     		= wrf_interp_3d_z(pv,z,interp_levels(j))
		end do
		printVarSummary(rw_int)
;transform to polar coordinate
		ilat               = centi(nf,k)
		ilon               = centj(nf,k)
		theta  = ispan(0,359,1)
		do l=0,ncir-1
			x_po(l,:) = ilon + l*cos(theta*pi/180)
			y_po(l,:) = ilat + l*sin(theta*pi/180)
		end do
		x_po_1    = ndtooned(x_po)
		y_po_1    = ndtooned(y_po)
		mdims 	  = dimsizes(rw_int)
		iy = mdims(1)      ;lat
		ix = mdims(2)      ;lon
		xi        = ispan(0,ix-1,1)  ;xi,yi are grid point
		yi        = ispan(0,iy-1,1)  ;in the wrfout file,xi is WE direction yi is SN                                          
		var1_lev  = linint2_points(xi,yi,rw_int,False,x_po_1,y_po_1,0)   
		var2_lev  = linint2_points(xi,yi,mw_int,False,x_po_1,y_po_1,0)   
		var3_lev  = linint2_points(xi,yi,div_int,False,x_po_1,y_po_1,0)   
		var4_lev  = linint2_points(xi,yi,pv_int,False,x_po_1,y_po_1,0)   

		printVarSummary(var1_lev)
		do j=0,dimsizes(interp_levels)-1
			rw_out(nf,k,j,:,:)   = onedtond(var1_lev(j,:),(/ncir,nrad/))
			mw_out(nf,k,j,:,:)   = onedtond(var2_lev(j,:),(/ncir,nrad/))
			div_out(nf,k,j,:,:)  = onedtond(var3_lev(j,:),(/ncir,nrad/))
			pv_out(nf,k,j,:,:)   = onedtond(var4_lev(j,:),(/ncir,nrad/))
		end do
		k = k + 1
		print((/k/))
	end do		
end do
	g             		 = addfile("amz_masflux.nc","c")

	rw_avg         		 = dim_avg_n(rw_out,4) 
	mw_avg       		 = dim_avg_n(mw_out,4)
	div_avg       		 = dim_avg_n(div_out,4)
	pv_avg       		 = dim_avg_n(pv_out,4)

	
	rw_avg!0              = "exam"
	rw_avg!1              = "time"
	rw_avg!2              = "lev"
	rw_avg!3              = "radus"
	copy_VarCoords(rw_avg,mw_avg)
	copy_VarCoords(rw_avg,div_avg)
	copy_VarCoords(rw_avg,pv_avg)

	g->amz_rw            = rw_avg
	g->amz_mw            = mw_avg
	g->amz_div           = div_avg 
	g->amz_pv            = pv_avg 

	
end

