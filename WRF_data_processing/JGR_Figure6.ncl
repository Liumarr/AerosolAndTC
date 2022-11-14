begin

    ;; file name and direction
	;dir      = "../DATA/"
	filename = (/"data/amz_RH.nc"/)
	plotType  = "pdf"       ; send graphics to PNG file
    plotName  = "picture/Figure6"

	;; read and process data
    f       			   = addfile(filename,"r")  
    g                      = addfile("data/hydro.nc","r")

	iwc                    = 1000*(g->iwc)
	lwc                    = 1000*(g->lwc)
	swc                    = 1000*(g->swc)	
	iwc                    = iwc+lwc+swc

	ccn_t1                 = dim_avg_n(f->sum_ccn(:,6:14,:,:),1)
	ccn_t2                 = dim_avg_n(f->sum_ccn(:,8:16,:,:),1)



	plot_ccn               = ccn_t1(1,:,:) - ccn_t1(0,:,:)
	plot_ccn2    		   = ccn_t2(1,:,:) - ccn_t2(0,:,:)

	ccn_innr               = dim_avg_n(f->sum_ccn(:,:,:,:50),3)
	ccn_outer              = dim_avg_n(f->sum_ccn(:,:,:,67:),3)
	iwc_innr               = dim_avg_n(iwc(:,:,:,:50),3)
	iwc_outer              = dim_avg_n(iwc(:,:,:,67:),3)
	printVarSummary(ccn_innr)


	lev                = fspan(0.1,14,40)
	time               = ispan(24,72,3)
	exam               = ispan(0,2,1)
	ccn_innr!0                = "exam"
	ccn_innr!1                = "time"
	ccn_innr!2                = "lev"
	
	ccn_innr&exam              = exam
	ccn_innr&lev              = lev
	ccn_innr&time             = time
	
	ridus               = ispan(0,300,3)

	plot_ccn!0               = "lev"
	plot_ccn!1               = "r"

	plot_ccn&lev             = lev
	plot_ccn&r               = ridus
	
	;copy_VarCoords(rw,mw)
	;copy_VarCoords(rw,div)
	copy_VarCoords(plot_ccn,plot_ccn2)
	;copy_VarCoords(iwc,avo)
	copy_VarCoords(ccn_innr,ccn_outer)

	printMinMax(plot_ccn,-1)
	printMinMax(plot_ccn2,-1)
	printMinMax(ccn_innr,-1)
	printMinMax(ccn_outer,-1)
	
;;;;;;;;;;;;;;;;;;;
;;   plot part   
;;;;;;;;;;;;;;;;;;;

    plot = new(4,"graphic")


	
    wks   = gsn_open_wks(plotType,plotName) ; send graphics to PNG file
	res                             = True
	res@txFont                      = 25
    res@gsnDraw                     = False
    res@gsnFrame                    = False
	res@vpWidthF                    = 0.3            ; Change the aspect ratio, but 
    res@vpHeightF                   = 0.3  
	res@gsnLeftString               = ""
    res@gsnRightString              = ""
	cmap  = read_colormap_file("WhiteBlueGreenYellowRed")
    cmap2 = read_colormap_file("NCV_blu_red")	

    res@cnLinesOn                   = False
    res@cnFillOn                    = True
	res@cnInfoLabelOn               = False
	res@lbLabelBarOn                = False
	res@cnLineLabelsOn             =  False
	res@tmXBMajorOutwardLengthF    = -0.001
	res@tmXBMinorOutwardLengthF    = -0.001
    res@tmYLMajorOutwardLengthF    = -0.001
    res@tmYLMinorOutwardLengthF    = -0.001
    res@tmYRMajorOutwardLengthF    = -0.001
    res@tmYRMinorOutwardLengthF    = -0.001
	res@gsnLeftStringFontHeightF   = 0.014
	res@tmXBLabelFontHeightF        = 0.014
    res@tmXTLabelFontHeightF        = 0.014
    res@tmYLLabelFontHeightF        = 0.014
	res@lbTitleFontHeightF          = 0.014
	res@lbLabelFontHeightF          = 0.014
	res@tmYLMode               = "Explicit"
	res@tmYLValues        		= ispan(0,14,2)
    res@tmYLLabels       		= (/"0","2","4","6","8","10","12","14"/)
	res@lbTitlePosition            = "bottom"
    res@tiXAxisString    = ""
	res@cnLevelSelectionMode = "ManualLevels" ; Set manual contour levels
	
	res1                  = res
	;res1@lbOrientation = "Vertical"
	res1@cnFillPalette   = cmap2	
	res1@cnMinLevelValF       = -5.0
	res1@cnMaxLevelValF       = 5.0
	res1@cnLevelSpacingF      = 1.0
	;res1@cnFillMode            = "RasterFill"
	res1@cnRasterSmoothingOn   = True
	res1@lbBoxLinesOn          = False 
	;res1@lbLabelStride         = 10
	res1@lbTitleString         = "~F8~D~F25~CCN (ug~F34~W~F25~kg~S~-1~N~)"
	res1@trYMinF               = 0  
    res1@trYMaxF               = 6  
	
	res@cnFillPalette    = cmap	
	res@trXMinF          = 24  ; You could also just use
    res@trXMaxF          = 72   ; min/max of u0,u1,u2.
	
    res@tmXBValues       = ispan(24,72,24)
	res@tmXBMode         = "Explicit"
    res@tmXBLabels       = (/"24 h","48 h","72 h"/)
	res@trYMinF          = 0  ; You could also just use
    res@trYMaxF          = 6   ; min/max of u0,u1,u2.	
	res1    = res
	res1@tiYAxisString    		   = "~F25~Height (km)"
	res1@cnMinLevelValF       = 0
	res1@cnMaxLevelValF       = 20
	res1@cnLevelSpacingF      = 2
	res1@cnLevelSelectionMode = "ManualLevels"
	; res1@cnMinLevelValF       = 0.0
	; res1@cnMaxLevelValF       = 20.0
	; res1@cnLevelSpacingF      = 0.1
	; res1@cnFillMode            = "RasterFill"
	; res1@cnRasterSmoothingOn   = True
	res1@lbBoxLinesOn          = True 
	res1@lbLabelStride         = 1
	res1@lbLabelAutoStride     = False
	;res1@cnSmoothingOn         = True
	
	res1@lbTitleString   = "~F25~CCN (ug~F34~W~F25~kg~S~-1~N~)"
	;res1@lbOrientation = "Vertical"
	
	res2    = res
	res2@cnFillOn                    = False
	res2@cnLineThicknessF            = 2
	res2@cnLinesOn                   = True
	res2@cnLineLabelsOn    		     = True
	res2@cnLineLabelFont             = 25
	res2@cnLineLabelFontHeightF      = 0.008
	res2@cnLineLabelPlacementMode    = "Constant"
	res2@cnLevelSelectionMode        = "ExplicitLevels"
	res2@cnLevels                    = (/0.4,0.6,0.8/)
	res2@cnLineDashSegLenF           = 0.1
	res2@cnLineLabelInterval         = 1
	res2@cnLineColor                = "maroon3";"darkorange1";"lightsalmon"
	res2@cnLineDashSegLenF          = 0.15
	res2@cnExplicitLineLabelsOn     = True
	res2@cnLineLabelStrings         = (/"0.4","0.6","0.8"/)
	res2@cnSmoothingOn              = True



	printVarSummary(ccn_innr)
	ccn_innr1   = ccn_innr({exam|:},{lev|:},{time|:})
	ccn_outer1  = ccn_outer({exam|:},{lev|:},{time|:})

	plot(0) =  gsn_csm_contour(wks,ccn_innr1(0,:,:),res1)
	plot(2) =  gsn_csm_contour(wks,ccn_innr1(1,:,:),res1)

	plot(1) =  gsn_csm_contour(wks,ccn_outer1(0,:,:),res1)
	plot(3) =  gsn_csm_contour(wks,ccn_outer1(1,:,:),res1)
	
	; plot(2) = gsn_csm_contour(wks,plot_ccn,res1) 
    ; plot(5) = gsn_csm_contour(wks,plot_ccn2,res1) 
		
		
		
		
	

	; p_line               = new(4, graphic)
	; resLine                   = True
	; resLine@gsLineColor       = "black" 
	; resLine@gsLineDashPattern = 2
	; resLine@gsLineThicknessF  = 3

		; p_line(0)        = gsn_add_polyline(wks,plot(0),(/64,64/),\
							; (/0,12/),resLine)  		
		; p_line(1)        = gsn_add_polyline(wks,plot(0),(/60,60/),\
							; (/0,12/),resLine)  								
		; p_line(2)        = gsn_add_polyline(wks,plot(1),(/64,64/),\
							; (/0,12/),resLine)  		
		; p_line(3)        = gsn_add_polyline(wks,plot(1),(/60,60/),\
							; (/0,12/),resLine)  
							
    ; resLine@gsLineThicknessF  = 3
	; resLine@gsLineDashPattern = 0
	; resLine@gsLineColor   = "blue4"
	; rmw_line0            = gsn_add_polyline(wks,plot(2),rmw(0,:27),\
									; lev(:27),resLine)  
	; rmw_line1            = gsn_add_polyline(wks,plot(5),rmw(2,:27),\
									; lev(:27),resLine)  	
	; rmw_line2            = gsn_add_polyline(wks,plot(8),rmw(1,:27),\
									; lev(:27),resLine)  
    resP                     = True                ; modify the panel plot
	resP@gsnMaximize         = True
	resP@gsnPanelTop         = 0.98
	resP@gsnPanelBottom      = 0.05
	resP@gsnPanelLeft        = 0.05
	resP@gsnPanelLabelBar = True
	resP@lbLabelFont      = 25
	resP@lbLabelFontHeightF = 0.014
	resP@lbTitleString      = "~F25~CCN (ug~F34~W~F25~kg~S~-1~N~)"
	resP@lbTitleFontHeightF = 0.014
	resP@lbTitlePosition   = "Bottom"
	resP@lbBoxLinesOn      = True
	resP@lbLabelStride        = 1
	resP@pmLabelBarWidthF     = 0.5    
	resP@pmLabelBarHeightF    = 0.1	
	
	
	
   ; gsn_panel(wks,(/plot(2),plot(5),plot(8)/),(/3,1/),resP)               ; now draw as one plot
    gsn_panel(wks,plot,(/2,2/),resP) 
  
end


