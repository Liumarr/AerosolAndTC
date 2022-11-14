begin

;   filename 
	dir      = "data/"
	filename = (/"amz_data.nc","amz_data_CTL-2.nc"/)
	plotType = "pdf"       ; send graphics to PNG file
    plotName = (/"picture/JGR-figure2-t2-1","picture/JGR-figure2-pro"/)
	
    f       			 = addfiles(dir+filename,"r")      
    wks  = gsn_open_wks(plotType,plotName(0)) ; send graphics to PNG file
	wks2 = gsn_open_wks(plotType,plotName(1)) ; send graphics to PNG file
;   read and process data  
	
;	8:16
	avo                     = dim_avg_n(f[0]->amz_avo(:,6:13,:,:),1)
	rh                      = dim_avg_n(f[0]->amz_rh(:,6:13,:,:),1)
	
	ctl_avo              	= dim_avg_n(f[1]->amz_avo(:,6:13,:,:),1)
	ctl_rh                  = dim_avg_n(f[1]->amz_rh(:,6:13,:,:),1)	

	ARI_avo                 = avo(0,:,:) - ctl_avo(0,:,:)
	ACI_avo                 = avo(1,:,:) - ctl_avo(0,:,:)
	total_avo               = avo(2,:,:) - ctl_avo(0,:,:)
	
	ARI_rh                  = rh(0,:,:)  - ctl_rh(0,:,:)
	ACI_rh                  = rh(1,:,:)  - ctl_rh(0,:,:)
	total_rh                = rh(2,:,:)  - ctl_rh(0,:,:)
	
	printMinMax(ARI_avo,-1)
	printMinMax(ACI_avo,-1)
	
	lev                 = fspan(0.1,14,40)
	ridus               = ispan(0,300,3)

	ARI_avo!0           = "lev"
	ARI_avo!1           = "r"
	ARI_avo&lev         = lev
	ARI_avo&r           = ridus

	rh!1           = "lev"
	rh!2           = "r"
	rh&lev         = lev
	rh&r           = ridus

	copy_VarCoords(ARI_avo,ACI_avo)
	copy_VarCoords(ARI_avo,ACI_rh)
	copy_VarCoords(ARI_avo,ARI_rh)
	copy_VarCoords(ARI_avo,total_rh)
	copy_VarCoords(ARI_avo,total_avo)
	copy_VarCoords(rh,avo)

	
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
	
	ARI_v           = avg_u(0,:,:) - avg_ctl_u(0,:,:)
	ACI_v           = avg_u(1,:,:) - avg_ctl_u(0,:,:)
	total_v         = avg_u(2,:,:) - avg_ctl_u(0,:,:)
	copy_VarCoords(ARI_avo,ACI_v)
	copy_VarCoords(ARI_avo,ARI_v)
	copy_VarCoords(ARI_avo,total_v)
	copy_VarCoords(rh,avg_u)
	
	printVarSummary(ARI_avo)
	printVarSummary(ARI_v)
	
	; printVarSummary(avg_radial_u)
	; printMinMax(avg_radial_u,-1)
	

	; ;;;;;;;;;;;;;
	; plot part
	; ;;;;;;;;;;;;;
	
	uplot = new(8,"graphic")
    plot = new(8,"graphic")

	colors                = (/"grey35","salmon","royalblue1"/)
	res                             = True
	res@txFont                      = 25
    res@gsnDraw                     = False
    res@gsnFrame                    = False
	res@vpWidthF                    = 0.25           ; Change the aspect ratio, 
    res@vpHeightF                   = 0.25  
	res@gsnLeftString               = ""
    res@gsnRightString              = ""
	res@tmXBMajorOutwardLengthF    = -0.0006
	res@tmXBMinorOutwardLengthF    = -0.0006
    res@tmYLMajorOutwardLengthF    = -0.0006
    res@tmYLMinorOutwardLengthF    = -0.0006
    res@tmYRMajorOutwardLengthF    = -0.0006
    res@tmYRMinorOutwardLengthF    = -0.0006
	res@tmXBLabelFontHeightF        = 0.014
    res@tmXTLabelFontHeightF        = 0.014
    res@tmYLLabelFontHeightF        = 0.014
	res@tmYLMode               = "Explicit"
	res@tmYLValues        		= ispan(0,14,2)
    res@tmYLLabels       		= (/"0","2","4","6","8","10","12","14"/)
	res@lbLabelFontHeightF         = 0.014
	res@lbTitleFontHeightF         = 0.014
	xyres                          =  res
	res@gsnLeftStringFontHeightF   = 0.014
	res@tiYAxisFontHeightF         = 0.014
	res@tiXAxisFontHeightF         = 0.014
	res@tiYAxisFont                = 25
	res@tiYAxisString    		   = "Height (km)"

	res@pmLabelBarOrthogonalPosF   = 0.06
	cmap  = read_colormap_file("WhiteBlueGreenYellowRed")
	cmap2 = read_colormap_file("NCV_blu_red")  ;MPL_Bu
    res@cnLinesOn                   = False
    res@cnFillOn                    = True
	res@cnInfoLabelOn               = False
	res@lbLabelBarOn                = True
	res@lbTitleFontHeightF          = 0.014
    res@lbTitlePosition      = "Bottom"
	res@cnLineLabelsOn    			=  False
	res@trYMinF               = 0  
    res@trYMaxF               = 12  
	
	res1    = res
	res2    = res
	res3    = res
	res4    = res
	res5    = res
	res6    = res
	res7    = res

    res@cnFillPalette           = cmap	
	res1@cnFillPalette          = cmap
	res2@cnFillPalette           = cmap2	
	res3@cnFillPalette           = cmap	
	res5@cnFillPalette           = cmap2
	res6@cnFillPalette           = cmap2	
	


	res1@lbTitleString    = "~F25~RH (%)"
	res5@lbTitleString    = "~F8~D~F25~RH (%)"
	res2@lbTitleString    = "~F25~Radial wind (m/s)"
	res6@lbTitleString    = "~F8~D~F25~Radial wind (m/s)"
	res3@gsnLeftString    = "~F8~D~F25~RH(%)"
	
	
	res@cnLevelSelectionMode   = "ManualLevels" ; Set manual contour levels
	res@cnMinLevelValF         = 30
	res@cnMaxLevelValF         = 50
	res@cnLevelSpacingF        = 5
	res@cnFillOn               = False
	res@cnLineThicknessF       = 1.4
	res@cnLinesOn              = True
	res@cnLineLabelsOn    		= True
	res@cnLineLabelFont        = 25
	res@cnLineLabelFontHeightF = 0.012
	res@cnLineLabelPlacementMode = "Constant"
	res@cnLineDashSegLenF      = 0.12
	res@cnLineLabelInterval    = 1
	
	
	res1@cnLevelSelectionMode   = "ManualLevels" ; Set manual contour levels
	res1@cnMinLevelValF         = 50
	res1@cnMaxLevelValF         = 100
	res1@cnLevelSpacingF        = 2
	res1@lbLabelStride           = 5
	res1@cnFillMode             = "RasterFill"
	res1@cnRasterSmoothingOn    = True
	res1@lbBoxLinesOn          = False 
	res2@cnLevelSelectionMode   = "ManualLevels" ; Set manual contour levels
	res2@cnFillMode             = "RasterFill"
	res2@cnRasterSmoothingOn    = True	
	res2@cnMinLevelValF         = -4
	res2@cnMaxLevelValF         = 4
	res2@cnLevelSpacingF        = 0.1
	res2@lbLabelStride           = 10
	res2@lbBoxLinesOn          = False 
	res2@tiXAxisString    		   = "~F25~Radius (km)"
	res3@cnLevelSelectionMode   = "ManualLevels" ; Set manual contour levels
	res3@cnMinLevelValF         = -20
	res3@cnMaxLevelValF         = 20
	res3@cnLevelSpacingF        = 2
	
	res7@cnFillOn               = False
	res7@cnLineThicknessF       = 1
	res7@cnLineDashPattern      = 16
	res7@cnLineColor            = "grey"
	res7@cnLinesOn              = True
	res7@cnLineLabelsOn    		= False
	res7@cnLineLabelFont        = 25
	res7@cnLineLabelFontHeightF = 0.01
	res7@cnLineLabelPlacementMode = "Constant"
	res7@cnLevelSelectionMode   = "ExplicitLevels"
	res7@cnLevels               = (/0/)
	
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
	res8                        = res4
	res4@cnLineDashPattern      = 0
	res4@cnLevels               = (/10,20,30/)	

	res8@cnLevels               = (/-5,5/)	
	res8@cnLineDashPatterns      = (/16,0/)
	; res8@cnMonoLineDashPattern   = False
    res8@cnLineLabelFontHeightF = 0.012


	plot(0)                      = gsn_csm_contour(wks,rh(2,:,:),res1)
	uplot(4)                    = gsn_csm_contour(wks,avo(2,:,:),res4)
	plot(4)                      = gsn_csm_contour(wks,avg_u(2,:,:),res2)
	;overlay(plot(0),uplot(0))
	overlay(plot(4),uplot(4))
	
	res5@cnFillMode             = "RasterFill"
	res5@cnRasterSmoothingOn    = True
	res5@lbBoxLinesOn          = False 
	res5@cnLevelSelectionMode   = "ManualLevels" ; Set manual contour levels
	res5@cnMinLevelValF         = -20
	res5@cnMaxLevelValF         = 20
	res5@cnLevelSpacingF        = 0.5
	res5@lbLabelStride          = 10	
	
	
	res6@cnFillMode             = "RasterFill"
	res6@cnRasterSmoothingOn    = True
	res6@lbBoxLinesOn          = False 
	res6@cnLevelSelectionMode   = "ManualLevels" ; Set manual contour levels
	res6@cnMinLevelValF         = -1.5
	res6@cnMaxLevelValF         = 1.5
	res6@cnLevelSpacingF        = 0.05
	res6@lbLabelStride           = 10
	

	res@cnLevelSelectionMode   = "ExplicitLevels"
	res@cnLevels               = (/-10,10/)	
	res@cnLineDashPatterns      = (/16,0/)
	res@cnMonoLineDashPattern   = False
	res@trYMinF         		   = 0  ; You could also just use
    res@trYMaxF         		   = 8	
	
	res6@cnMinLevelValF         = -1.6
	res6@cnMaxLevelValF         = 1.6
	res6@cnLevelSpacingF        = 0.04
	res6@tiXAxisString    		   = "~F25~Radius (km)"
	res5@cnMinLevelValF         = -20
	res5@cnMaxLevelValF         = 20
	res5@cnLevelSpacingF        = 0.5
	res5@tiYAxisString          = ""
	res6@tiYAxisString          = ""
	res7@tiYAxisString          = ""
	res8@tiYAxisString          = ""

	plot(1)              = gsn_csm_contour(wks,ARI_rh,res5)
	plot(2)              = gsn_csm_contour(wks,ACI_rh,res5)
	plot(3)              = gsn_csm_contour(wks,total_rh,res5)
	
	plot(5)              = gsn_csm_contour(wks,ARI_v,res6)
	plot(6)              = gsn_csm_contour(wks,ACI_v,res6)	
	plot(7)              = gsn_csm_contour(wks,total_v,res6)
	
	uplot(0)             = gsn_csm_contour(wks,ARI_v,res7)
	uplot(1)             = gsn_csm_contour(wks,ACI_v,res7)
	uplot(2)             = gsn_csm_contour(wks,total_v,res7)
	
	uplot(3)             = gsn_csm_contour(wks,ARI_rh,res7)
	uplot(4)             = gsn_csm_contour(wks,ACI_rh,res7)
	uplot(5)             = gsn_csm_contour(wks,total_rh,res7)
	
	
	overlay(plot(5),uplot(0))
	overlay(plot(6),uplot(1))
	overlay(plot(7),uplot(2))
	
	
	overlay(plot(1),uplot(3))
	overlay(plot(2),uplot(4))
	overlay(plot(3),uplot(5))
	
	avoplot            = gsn_csm_contour(wks,ARI_avo,res8)
	avoplot2           = gsn_csm_contour(wks,ACI_avo,res8)
	avoplot3           = gsn_csm_contour(wks,total_avo,res8)
	
	overlay(plot(5),avoplot)
	overlay(plot(6),avoplot2)
	overlay(plot(7),avoplot3)
charL                       = (/"(a) CTL","(b) ARI","(c) ACI","(d) Tot","(e) CTL","(f) ARI","(g) ACI", "(h) Tot"/)
	legend                      = new(8,graphic)
	resT                             = True
	resT@txFont        = 25 
    resT@txFontHeightF = 0.014
    resT@txFontColor = "black"
    resT@txJust = "BottomLeft"
	resT@txFontThicknessF = 2.0
	do i=0,dimsizes(charL)-1
		legend(i)                = gsn_add_text(wks,plot(i),charL(i),10.0,10.5,resT)
	end do
		


 

    resP                     = True                ; modify the panel plot
	resP@gsnPanelTop         = 0.9
	resP@gsnPanelBottom      = 0.05

  gsn_panel(wks,plot,(/2,4/),resP)
    ;gsn_panel(wks2,pro_plot,(/2,1/),resP)

end


