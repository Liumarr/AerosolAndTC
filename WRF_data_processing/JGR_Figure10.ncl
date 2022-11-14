begin

    ;; file name and direction
	dir      = "data/"
	filename = (/"amz_data.nc","amz_data_CTL-2.nc","hydro.nc","ctl_hydro2.nc"/)
	plotType  = "pdf"       ; send graphics to PNG file
    plotName  = "picture/Figure10-1"

	;; read and process data
    f          = addfiles(dir+filename,"r")  
	
	avo                     = dim_avg_n(f[0]->amz_avo(:,6:13,:,:),1)
	rh                      = dim_avg_n(f[0]->amz_rh(:,6:13,:,:),1)

	ctl_avo              	= dim_avg_n(f[1]->amz_avo(:,6:13,:,:),1)
	ctl_rh                  = dim_avg_n(f[1]->amz_rh(:,6:13,:,:),1)	
	
	nolin_rh                  = rh(2,:,:) + ctl_rh(0,:,:) - rh(0,:,:)- rh(1,:,:)
	nolin_avo                 = avo(2,:,:) + ctl_avo(0,:,:) - avo(0,:,:)- avo(1,:,:)	
	
	u             = dim_avg_n(f[0]->amz_u(:,6:13,:,:,:),1)
    v             = dim_avg_n(f[0]->amz_v(:,6:13,:,:,:),1)
	ctl_u         = dim_avg_n(f[1]->amz_u(:,6:13,:,:,:),1)
    ctl_v         = dim_avg_n(f[1]->amz_v(:,6:13,:,:,:),1)	

	radial_u      = new(dimsizes(u),float,0)
	ctl_radial_u  = new(dimsizes(ctl_u),float,0)
	
	;  compute radial wind 
	do i=0,359
		theta                    = i*3.14159265/180
		radial_u(:,:,:,i)        = 1*(v(:,:,:,i)*sin(theta)+u(:,:,:,i)*cos(theta))
		ctl_radial_u(:,:,:,i)    = 1*(ctl_v(:,:,:,i)*sin(theta)+ctl_u(:,:,:,i)*cos(theta))
	end do
	
	avg_u            = dim_avg_n_Wrap(radial_u,3)
	avg_ctl_u        = dim_avg_n_Wrap(ctl_radial_u,3)
	
	nolin_v           = avg_u(2,:,:) + avg_ctl_u(1,:,:) - avg_u(0,:,:) - avg_u(1,:,:)

	iwc                 = 1000*(dim_avg_n(f[2]->iwc(:,6:13,:,:),1))
	lwc                 = 1000*(dim_avg_n(f[2]->lwc(:,6:13,:,:),1))
	swc                 = 1000*(dim_avg_n(f[2]->swc(:,6:13,:,:),1))	
	gwc                 = 1000*(dim_avg_n(f[2]->gwc(:,6:13,:,:),1))
	
	ctl_iwc                 = 1000*(dim_avg_n(f[3]->iwc(:,6:13,:,:),1))
	ctl_lwc                 = 1000*(dim_avg_n(f[3]->lwc(:,6:13,:,:),1))
	ctl_swc                 = 1000*(dim_avg_n(f[3]->swc(:,6:13,:,:),1))	
	ctl_gwc                 = 1000*(dim_avg_n(f[3]->gwc(:,6:13,:,:),1))
	
	iwc                 = iwc+gwc+swc
    ctl_iwc             = ctl_iwc+ctl_gwc+ctl_swc
	nolin_iwc           = ctl_iwc(0,:,:)+iwc(2,:,:) -iwc(1,:,:) - iwc(0,:,:)
	nolin_lwc           = lwc(2,:,:) + ctl_lwc(0,:,:)-lwc(1,:,:) - lwc(0,:,:)
	printVarSummary(iwc)



	lev                = fspan(0.1,14,40)
	ridus               = ispan(0,300,3)

	nolin_avo!0               = "lev"
	nolin_avo!1               = "r"
	nolin_avo&lev             = lev
	nolin_avo&r               = ridus

	

	copy_VarCoords(nolin_avo,nolin_rh)
	copy_VarCoords(nolin_avo,nolin_v)
	copy_VarCoords(nolin_avo,nolin_lwc)
	copy_VarCoords(nolin_avo,nolin_iwc)

	
	printVarSummary(nolin_avo)
	printVarSummary(nolin_iwc)

;;;;;;;;;;;;;;;;;;;
;;   plot part   
;;;;;;;;;;;;;;;;;;;

    plot = new(3,"graphic")

	
    wks   = gsn_open_wks(plotType,plotName) ; send graphics to PNG file
	res                             = True
	res@txFont                      = 25
    res@gsnDraw                     = False
    res@gsnFrame                    = False
	res@vpWidthF                    = 0.25            ; Change the aspect ratio, but 
    res@vpHeightF                   = 0.25  
	res@gsnLeftString               = ""
    res@gsnRightString              = ""

    cmap2 = read_colormap_file("NCV_blu_red")	

    res@cnLinesOn                   = False
    res@cnFillOn                    = True
	res@cnInfoLabelOn               = False
	res@lbLabelBarOn                = True
	res@cnLineLabelsOn             =  False
	res@tmXBMajorOutwardLengthF    = -0.001
	res@tmXBMinorOutwardLengthF    = -0.001
    res@tmYLMajorOutwardLengthF    = -0.001
    res@tmYLMinorOutwardLengthF    = -0.001
    res@tmYRMajorOutwardLengthF    = -0.001
    res@tmYRMinorOutwardLengthF    = -0.001
	res@gsnLeftStringFontHeightF   = 0.012
	res@tmXBLabelFontHeightF        = 0.012
    res@tmXTLabelFontHeightF        = 0.012
    res@tmYLLabelFontHeightF        = 0.012
	res@lbTitleFontHeightF          = 0.012
	res@lbLabelFontHeightF          = 0.012
	res@tiXAxisFontHeightF          = 0.012
	res@tiYAxisFontHeightF          = 0.012
	res@tmYLMode               = "Explicit"
	res@tmYLValues        		= ispan(0,12,2)
    res@tmYLLabels       		= (/"0","2","4","6","8","10","12"/)
	res@lbTitlePosition            = "bottom"
    res@tiXAxisString    = ""
	res@cnLevelSelectionMode = "ManualLevels" ; Set manual contour levels
	res@cnFillPalette   = cmap2		
	res@trYMinF               = 0  
    res@trYMaxF               = 12  
	res@tiXAxisString    		   = "~F25~Radius (km)"
	res@tiYAxisString    		   = "~F25~Height (km)"
	
	res7                  = res
	res8                  = res
	res1                  = res
	res2                  = res
	res3                  = res
	res4                  = res

	
	res1@cnFillMode             = "RasterFill"
	res1@cnRasterSmoothingOn    = True
	res1@lbBoxLinesOn          = False 
	res1@cnLevelSelectionMode   = "ManualLevels" ; Set manual contour levels
	res1@cnMinLevelValF         = -20
	res1@cnMaxLevelValF         = 20
	res1@cnLevelSpacingF        = 0.5
	res1@lbLabelStride          = 10	
	
	
	res2@cnFillMode             = "RasterFill"
	res2@cnRasterSmoothingOn    = True
	res2@lbBoxLinesOn          = False 
	res2@cnLevelSelectionMode   = "ManualLevels" ; Set manual contour levels
	res2@cnMinLevelValF         = -1.5
	res2@cnMaxLevelValF         = 1.5
	res2@cnLevelSpacingF        = 0.05
	res2@lbLabelStride           = 10
	res2@lbTitleString         = "~F8~D~F25~Radial Wind (m/s)"


	res@cnLevelSelectionMode   = "ExplicitLevels"
	res@cnLevels               = (/-10,10/)	
	res@cnLineDashPatterns      = (/16,0/)
	res@cnMonoLineDashPattern   = False
	res@trYMinF         		   = 0  ; You could also just use
    res@trYMaxF         		   = 8	
	


	res3@cnFillOn               = False
	res3@cnLineThicknessF       = 1
	res3@cnLineDashPattern      = 16
	res3@cnLineColor            = "grey"
	res3@cnLinesOn              = True
	res3@cnLineLabelsOn    		= False
	res3@cnLineLabelFont        = 25
	res3@cnLineLabelFontHeightF = 0.01
	res3@cnLineLabelPlacementMode = "Constant"
	res3@cnLevelSelectionMode   = "ExplicitLevels"
	res3@cnLevels               = (/0/)
	
	res4@cnFillOn               = False
	res4@cnLineThicknessF       = 1.6
	res4@cnLinesOn              = True	
	;res4@cnLineColor           = ""
	res4@cnLineLabelsOn    		= True
	res4@cnLineLabelFont        = 25
	res4@cnLineLabelFontHeightF = 0.01
	res4@cnLineLabelPlacementMode = "Constant"
	res4@cnLevelSelectionMode   = "ExplicitLevels"
	res4@cnLineDashSegLenF      = 0.15
	res4@cnLineLabelInterval    = 1	
	res4@cnLineDashPattern      = 0
	res4@cnLevels               = -5

	res8@cnFillOn               = False
	res8@cnLineThicknessF       = 1.6
	res8@cnLinesOn              = True	
	;res4@cnLineColor           = ""
	res8@cnLineLabelsOn    		= False
	res8@cnLineLabelFont        = 25
	res8@cnLineLabelFontHeightF = 0.01
	res8@cnLineLabelPlacementMode = "Constant"
	res8@cnLevelSelectionMode   = "ExplicitLevels"
	res8@cnLineDashSegLenF      = 0.18
	res8@cnLineLabelInterval    = 1	
	res8@cnLineDashPatterns      = (/2,2,0,0/)
	res8@cnLevels               = -0.1
	res8@cnMonoLineDashPattern   = False





	

	res7@cnMinLevelValF       = -0.8
	res7@cnMaxLevelValF       = 0.8
	res7@cnLevelSpacingF      = 0.02
	res7@cnFillMode            = "RasterFill"
	res7@cnRasterSmoothingOn   = True
	res7@lbBoxLinesOn          = False 
	res7@lbLabelStride         = 10
	res7@lbTitleString         = "~F8~D~F25~IWC (g~F34~W~F25~kg~S~-1~N~)"

	



	plot(0)       = gsn_csm_contour(wks,nolin_rh,res1) 
	plot(1) 	  = gsn_csm_contour(wks,nolin_v,res2) 
	uplot         = gsn_csm_contour(wks,nolin_v,res3) 
	avoplot       = gsn_csm_contour(wks,nolin_avo,res4) 
	overlay(plot(1),avoplot)
	overlay(plot(1),uplot)
	
	plot(2) 	  = gsn_csm_contour(wks,nolin_iwc,res7) 
	; lwc_plot      = gsn_csm_contour(wks,nolin_lwc,res8) 
	; overlay(plot(2),lwc_plot)

	charL                       = (/"(a)","(b)"/)
	legend                      = new(2,graphic)
	resT                             = True
	resT@txFont        = 25 
    resT@txFontHeightF = 0.014
    resT@txFontColor = "black"
    resT@txJust = "BottomLeft"
	resT@txFontThicknessF = 2.0
	do i=1,2
		legend(i-1)                = gsn_add_text(wks,plot(i),charL(i-1),10.0,10.5,resT)
	end do
			


    resP                     = True                ; modify the panel plot
	resP@gsnMaximize         = True
	resP@gsnPanelTop         = 0.98
	resP@gsnPanelBottom      = 0.05
	resP@gsnPanelLeft        = 0.05
   ; gsn_panel(wks,(/plot(2),plot(5),plot(8)/),(/3,1/),resP)               ; now draw as one plot
    gsn_panel(wks,plot(1:),(/1,2/),resP) 
  
end


