;TC center profile

begin
	filename         = (/"RAD","CLD","CTL","CLEAN"/)
	dir              = "../"
	TCcent           = (/"CTL_cent.txt","MICRO_cent.txt","RAD_cent.txt","CLEAN_cent"/)
	nfile            = dimsizes(TCcent) 
	nrow             = numAsciiRow(dir+TCcent(0))
	centi            = new((/nfile,nrow/), "float")
	centj            = new((/nfile,nrow/), "float")
	do i=0, nfile-1
		data    = asciiread(dir+TCcent(i), -1, "string")
		centi(i,:)     = stringtofloat(str_get_field(data, 4, ",")) 
		centj(i,:)     = stringtofloat(str_get_field(data, 3, ",")) 
	end do

    f                = addfiles(dir+filename,"r")
	interp_levels    = fspan(100,14000,40)
	ncir             = 101                   
	pi               = 3.14159265
	nrad             = 360
	nx               = 399
	ny               = 399
	dx               = 3
	times            = 49
	x_po             = new((/ncir, nrad/),float)  ;generate polar coordinate
	y_po             = x_po
    u10_out          = new((/nfile,times,ncir,nrad/),float,0)
    v10_out          = new((/nfile,times,ncir,nrad/),float,0)

   
do nf = 0, nfile-1
;; acqur data
	k                = 0 
	do i=0,times-1,3
		u10                     = f[nf]->U10(i,:,:)
		v10                     = f[nf]->V10(i,:,:)
;transform to polar coordinate
		ilon               		= centi(nf,k)
		ilat               		= centj(nf,k)	
		theta  					= ispan(0,359,1)
		do l=0,ncir-1
			x_po(l,:) 			= ilon + l*cos(theta*pi/180)
			y_po(l,:) 			= ilat + l*sin(theta*pi/180)
		end do
		x_po_1    				= ndtooned(x_po)
		y_po_1    				= ndtooned(y_po)
		mdims 					= dimsizes(u10)
		iy 						= mdims(0)      ;lat
		ix 						= mdims(1)      ;lon
		xi        				= ispan(0,ix-1,1)  ;xi,yi are grid point
		yi        				= ispan(0,iy-1,1)  ;in the wrfout file,xi is WE direction yi is SN    
		var1_lev 				= linint2_points(xi,yi,u10,False,x_po_1,y_po_1,0) 
		var2_lev 				= linint2_points(xi,yi,v10,False,x_po_1,y_po_1,0) 
		u10_out(nf,k,:,:)   	= onedtond(var1_lev,(/ncir,nrad/))
		v10_out(nf,k,:,:)   	= onedtond(var2_lev,(/ncir,nrad/))
		k = k + 1
		print((/k/))
	end do		
end do

	tangen_u10    = new(dimsizes(u10_out),float,0)
	radial_u10    = new(dimsizes(u10_out),float,0)
	do i=0,359,1
		theta0                    = i*pi/180
		tangen_u10(:,:,:,i)       = v10_out(:,:,:,i)*cos(theta0)-u10_out(:,:,:,i)*sin(theta0)
		radial_u10(:,:,:,i)       = -1*(v10_out(:,:,:,i)*sin(theta0)+u10_out(:,:,:,i)*cos(theta0))
 	end do
	tangen_u10!0              = "exam"
	tangen_u10!1              = "time"
	tangen_u10!2              = "radus"
	tangen_u10!3              = "degree"
	copy_VarCoords(tangen_u10,radial_u10)
	g             		 	  = addfile("uv.nc","c")
	g->tangen_v               = tangen_u10
	g->radial_v               = tangen_u10

end

