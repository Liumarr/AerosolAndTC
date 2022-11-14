
	filename = (/"data/amz_ccn1.nc"/)
	plotType = "pdf"       ; send graphics to PNG file
	plotName = "picture/Figure8-2"


	f                   = addfile(filename,"r")      

	aod           	    = dim_sum_n(f->aod(:,6:14,:,:),1)
	ccn                 = dim_sum_n(f->ccn(:,6:14,:,:,:),1)
	ccn_l               = dim_sum_n(ccn,1)
	printVarSummary(ccn_l)
	delt_aod            = aod(1,:,:)- aod(0,:,:)
	delt_ccn            = ccn_l(1,:,:)- ccn_l(0,:,:)
	
	delt_ccn@_FillValue = -9999
	delt_aod@_FillValue = -9999
	print(sum(delt_ccn(33:,:)))
	printMinMax(delt_aod,-1)
	printMinMax(delt_ccn,-1)
	
	dis   = dimsizes(aod)
	printVarSummary(aod)
	DEGTORAD = 0.017453292519943
	x = new((/dis(1),dis(2)/), float)
	y = x
	printVarSummary(x)
	dx=9
	do i=0,dis(1)-1,1
		do j=0,dis(2)-1,1
			x(i,j) =  dx*i * cos(j*DEGTORAD)
			y(i,j) =  dx*i * sin(j*DEGTORAD)
		end do
	end do


	; plot = new(2,"graphic")
	; ;plot part
	; wks = gsn_open_wks(plotType,plotName)

	; cnres                   = True
	; cnres@vpWidthF                    = 0.28            ; Change the aspect ratio, but 
	; cnres@vpHeightF                   = 0.28  
	; cnres@txFont                      = 25
	; cnres@gsnDraw                     = False
	; cnres@gsnFrame                    = False
	; cnres@sfXArray          = x
	; cnres@sfYArray          = y
	; cnres@cnFillOn          = True
	; ; cnres@cnFillPalette     = "cmp_b2r"     ; set color map
	; cnres@cnFillPalette     = "NCV_blu_red"
	; cnres@cnLinesOn         = False
	
	; ;cnres@cnFillMode        = "RasterFill"      ; this mode is fastest
	; cnres@trGridType        = "TriangularMesh"
	; cnres@tmXBMajorOutwardLengthF = -0.001
	; cnres@tmXBMinorOutwardLengthF = -0.001
	; cnres@tmYLMajorOutwardLengthF = -0.001
	; cnres@tmYLMinorOutwardLengthF = -0.001
	; cnres@tmYRMajorOutwardLengthF = -0.001
	; cnres@tmYRMinorOutwardLengthF = -0.001
	; ;cnres@gsnLeftString  = "Radial Wind(m/s)"
	; cnres@lbTitleFontHeightF  = 0.01
	; cnres@lbTitlePosition  = "bottom"

	; cnres@lbTitleString   = "~F8~D~F25~AOD"
	; cnres@cnLevelSelectionMode = "ManualLevels" ; Set manual contour levels
	; cnres@cnMinLevelValF       = -0.5
	; cnres@cnMaxLevelValF       = 0.5
	; cnres@cnLevelSpacingF      = 0.01
	; cnres@lbLabelStride        = 10
		; cnres@cnFillMode             = "RasterFill"
	; cnres@cnRasterSmoothingOn    = True
	; cnres@lbBoxLinesOn          = False 

	; cnres@lbLabelFont                = 25
	; cnres@lbLabelFontHeightF         = 0.01
	; cnres@pmLabelBarOrthogonalPosF   = 0.06
	; cnres@tiYAxisFontHeightF   = 0.01
	; cnres@tiXAxisFontHeightF   = 0.01
	; cnres@tiYAxisString        = "~F25~Distance (km)"
	; cnres@tiXAxisString        = "~F25~Distance (km)"

	; plot(0) = gsn_csm_contour(wks,delt_aod,cnres)
	; cnres@cnMinLevelValF       = -10
	; cnres@cnMaxLevelValF       = 10
	; cnres@cnLevelSpacingF      = 0.5	
	; cnres@lbTitleString   = "~F8~D~F25~CCN (ug/kg)"
	
	; plot(1) = gsn_csm_contour(wks,delt_ccn,cnres)



	; p_line               = new(2, graphic)
	; p_line1               = new(2, graphic)
	; resLine                   = True
	; resLine@gsLineColor       = "black" 
	; resLine@gsLineDashPattern = 2
	; resLine@gsLineThicknessF  = 3.5
	; p_line1(0)        = gsn_add_polyline(wks,plot(0),(/0,0/),\
							; (/-800,800/),resLine)  			
	; p_line(0)        = gsn_add_polyline(wks,plot(0),(/-800,800/),\
							; (/0,0/),resLine)  									
	; p_line1(1)        = gsn_add_polyline(wks,plot(1),(/0,0/),\
							; (/-800,800/),resLine)  			
	; p_line(1)        = gsn_add_polyline(wks,plot(1),(/-800,800/),\
							; (/0,0/),resLine)  



	; poly = new((/2,7,400/),"graphic")
    ; poly2 = new((/2,7,400/),"graphic")
	; pl    = True
	; theta = fspan(0,6.28,400)
	; c     = cos(theta)
	; s     = sin(theta)
	; r     = fspan(-300,300,200)

	; poly(0,0,0) = gsn_add_polyline(wks,plot(0),c*300,s*300,resLine)
	; poly(1,0,0) = gsn_add_polyline(wks,plot(1),c*300,s*300,resLine)
	

	; gsn_panel(wks,plot,(/1,2/),True)               ; now draw as one plot
