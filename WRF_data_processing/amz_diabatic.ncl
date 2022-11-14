;2022.11.04 mar

begin
	filename         = (/"CTL","MICRO","RAD","CLEAN"/)
	;read tc center data
	TCcent           = (/"CTL_cent.txt","MICRO_cent.txt",\
	"RAD_cent.txt","CLEAN_cent.txt"/)
	nfile            = dimsizes(TCcent) 
	nrow             = numAsciiRow(TCcent(0))
	centi            = new((/nfile,nrow/), "float")
	centj            = new((/nfile,nrow/), "float")
	do i=0, nfile-1
		data    = asciiread(TCcent(i), -1, "string")
		centi(i,:)     = stringtofloat(str_get_field(data, 4, ",")) 
		centj(i,:)     = stringtofloat(str_get_field(data, 3, ",")) 
	end do

	dir              = "../"
    f                = addfiles(dir+filename,"r")
	ncir             = 201                   
	pi               = 3.14159265
	nrad             = 360
	nx               = 399
	ny               = 399
	dx               = 3
	times            = 17
	interp_levels    = fspan(100,14000,40)
	x_po             = new((/ncir, nrad/),float)  ;generate polar coordinate
	y_po             = x_po
    level            = dimsizes(interp_levels)

	lt_int           = new((/level,nx,ny/),float,0)
	sw_int           = new((/level,nx,ny/),float,0)
    lw_int           = new((/level,nx,ny/),float,0)
	eth_int          = new((/level,nx,ny/),float,0)

	lt_out           = new((/nfile,times,level,ncir,nrad/),float,0)
	sw_out           = new((/nfile,times,level,ncir,nrad/),float,0)
    lw_out           = new((/nfile,times,level,ncir,nrad/),float,0)
	eth_out          = new((/nfile,times,level,ncir,nrad/),float,0)
	
	
do nf = 0, 2
;; acqur data
	k                = 0 
	do i=0,times-1

		lt                    = 86400*(f[nf]->H_DIABATIC(i,:,:,:))
		lw                    = 86400*(f[nf]->RTHRATLW(i,:,:,:))
		sw                    = 86400*(f[nf]->RTHRATSW(i,:,:,:))
		eth                   = wrf_user_getvar(f[nf],"eth",i)
		z                     = wrf_user_getvar(f[nf],"z",i)
		do j=0,level-1
			lt_int(j,:,:)     = wrf_interp_3d_z(lt,z,interp_levels(j))
			sw_int(j,:,:)     = wrf_interp_3d_z(sw,z,interp_levels(j))
			lw_int(j,:,:)     = wrf_interp_3d_z(lw,z,interp_levels(j))
			eth_int(j,:,:)    = wrf_interp_3d_z(eth,z,interp_levels(j))
		end do
		
		printVarSummary(eth_int)
;transform to polar coordinate
		ilon               = centi(nf,k)
		ilat               = centj(nf,k)	
		theta  = ispan(0,359,1)
		do l=0,ncir-1
			x_po(l,:) = ilon + l*cos(theta*pi/180)
			y_po(l,:) = ilat + l*sin(theta*pi/180)
		end do
		x_po_1    = ndtooned(x_po)
		y_po_1    = ndtooned(y_po)
		mdims = dimsizes(lt_int)
		iy = mdims(1)      ;lat
		ix = mdims(2)      ;lon
		xi        = ispan(0,ix-1,1)  ;xi,yi are grid point
		yi        = ispan(0,iy-1,1)  ;in the wrfout file,xi is WE direction yi is SN    
		var1_lev = linint2_points(xi,yi,lt_int,False,x_po_1,y_po_1,0) 
		var2_lev = linint2_points(xi,yi,sw_int,False,x_po_1,y_po_1,0) 
		var3_lev = linint2_points(xi,yi,lw_int,False,x_po_1,y_po_1,0) 
		var4_lev = linint2_points(xi,yi,eth_int,False,x_po_1,y_po_1,0) 
		printVarSummary(var1_lev)
		
		do j=0,dimsizes(interp_levels)-1
			lt_out(nf,k,j,:,:) = onedtond(var1_lev(j,:),(/ncir,nrad/))
			sw_out(nf,k,j,:,:) = onedtond(var2_lev(j,:),(/ncir,nrad/))
			lw_out(nf,k,j,:,:) = onedtond(var3_lev(j,:),(/ncir,nrad/))
			eth_out(nf,k,j,:,:) = onedtond(var4_lev(j,:),(/ncir,nrad/))	
		end do
		k = k + 1
		print((/k/))
	end do		
end do
	lh_SE  = dim_avg_n(lh_out(:,:,:,:,270:),4)  
	sw_SE  = dim_avg_n(sw_out(:,:,:,:,270:),4) 
	lw_SE  = dim_avg_n(lw_out(:,:,:,:,270:),4) 
	eth_SE = dim_avg_n(eth_out(:,:,:,:,270:),4) 
	
	lt_avg = dim_avg_n(lt_out,4)
	sw_avg = dim_avg_n(sw_out,4)
	lw_avg = dim_avg_n(lt_out,4)
	eth_avg = dim_avg_n(eth_out,4)
	
	
	
	lt_avg!0              = "exam"
	lt_avg!1              = "time"
	lt_avg!2              = "lev"
	lt_avg!3              = "radus"

	copy_VarCoords(lt_avg,sw_avg)
	copy_VarCoords(lt_avg,lw_avg)	
	copy_VarCoords(lt_avg,eth_avg)
	copy_VarCoords(lt_avg,lt_SE)
	copy_VarCoords(lt_avg,sw_SE)
	copy_VarCoords(lt_avg,lw_SE)
	copy_VarCoords(lt_avg,eth_SE)

	
	g             		  = addfile("amz_daibatic.nc","c")
	g->lt_SE               = lt_SE
	g->sw_SE               = sw_SE
	g->lw_SE               = lw_SE
	g->eth_SE              = eth_SE
	
	g->lt_avg               = lt_avg
	g->sw_avg               = sw_avg
	g->lw_avg               = lw_avg
	g->eth_avg              = eth_avg
end

