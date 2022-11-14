begin

    ;; file name and direction
	;dir      = "../DATA/"
	filename = (/"data/hydro.nc","data/amz_RH.nc"/)
	plotType  = "pdf"       ; send graphics to PNG file
    plotName  = "picture/Figure7-t2"

	;; read and process data
    f       			 = addfiles(filename,"r")  


	iwc_t1                 = 1000*(dim_avg_n(f[0]->iwc(:,6:14,:,:),1))
	lwc_t1                 = 1000*(dim_avg_n(f[0]->lwc(:,6:14,:,:),1))
	swc_t1                 = 1000*(dim_avg_n(f[0]->swc(:,6:14,:,:),1))	
	gwc_t1                 = 1000*(dim_avg_n(f[0]->gwc(:,6:14,:,:),1))
	
	iwc_t2                 = 1000*(dim_avg_n(f[0]->iwc(:,8:16,:,:),1))
	lwc_t2                 = 1000*(dim_avg_n(f[0]->lwc(:,8:16,:,:),1))
	swc_t2                 = 1000*(dim_avg_n(f[0]->swc(:,8:16,:,:),1))	
	gwc_t2                 = 1000*(dim_avg_n(f[0]->gwc(:,8:16,:,:),1))	
	
	ccn_t1                 = dim_avg_n(f[1]->sum_ccn(:,6:14,:,:),1)
	ccn_t2                 = dim_avg_n(f[1]->sum_ccn(:,8:16,:,:),1)

	plot_ccn               = ccn_t1(1,:,:) - ccn_t1(0,:,:)
	plot_ccn2    		   = ccn_t2(1,:,:) - ccn_t2(0,:,:)
	
	iwc_t1              = iwc_t1+gwc_t1+swc_t1
	plot_iwc            = iwc_t1(2,:,:) - iwc_t1(1,:,:)
	plot_lwc   			= lwc_t1(2,:,:) - lwc_t1(1,:,:)

	
	iwc_t2              = iwc_t2+gwc_t2+swc_t2
	plot_iwc2    		= iwc_t2(2,:,:) - iwc_t2(1,:,:)
	plot_lwc2    		= lwc_t2(2,:,:) - lwc_t2(1,:,:)
	
	
	

	; iwc_t                 = 1000*(dim_avg_n(f->iwc(:,:,:,:67),3))
	; lwc_t                 = 1000*(dim_avg_n(f->lwc(:,:,:,:67),3))
	; swc_t                 = 1000*(dim_avg_n(f->swc(:,:,:,:67),3))	
	; gwc_t                 = 1000*(dim_avg_n(f->gwc(:,:,:,:67),3))	
	; hydrometor            = iwc_t+lwc_t+swc_t+gwc_t
	; printVarSummary(hydrometor)
	;printVarSummary(plot_lwc)
	; rw                  = 10^5*dim_avg_n(f[0]->amz_rw(:,:,:,:67),3)
	; mw                  = 10^3*dim_avg_n(f[0]->amz_mw(:,:,:,:67),3)
	; div                 = -1*10^5*dim_avg_n(f[0]->amz_div(:,:,:,:67),3)
	;printVarSummary(div)
	lev                = fspan(0.1,14,40)
	time               = ispan(24,72,3)
	exam               = ispan(0,2,1)
	; hydrometor!0                = "exam"
	; hydrometor!1                = "time"
	; hydrometor!2                = "lev"
	
	; hydrometor&exam              = exam
	; hydrometor&lev              = lev
	; hydrometor&time             = time
	
	ridus               = ispan(0,300,3)

	plot_lwc!0               = "lev"
	plot_lwc!1               = "r"

	plot_lwc&lev             = lev
	plot_lwc&r               = ridus
	
	;copy_VarCoords(rw,mw)
	;copy_VarCoords(rw,div)
	copy_VarCoords(plot_lwc,plot_lwc2)
	;copy_VarCoords(iwc,avo)
	copy_VarCoords(plot_lwc,plot_iwc)
	copy_VarCoords(plot_lwc,plot_ccn)
	copy_VarCoords(plot_lwc,plot_ccn2)
	copy_VarCoords(plot_lwc,plot_iwc2)
	;copy_VarCoords(rw,hydrometor)
	
	;printVarSummary(div)
	printVarSummary(plot_iwc)
	;printVarSummary(rw)
	;printVarSummary(mw)
	; printVarSummary(iwc)
	; printVarSummary(lwc)
    ; printVarSummary(hydrometor)
	; printMinMax(hydrometor,-1)

;;;;;;;;;;;;;;;;;;;
;;   plot part   
;;;;;;;;;;;;;;;;;;;

    plot = new(2,"graphic")

	hydro_plot = new(2,"graphic")
	lwc_plot   = new(2,"graphic")
	
    wks   = gsn_open_wks(plotType,plotName) ; send graphics to PNG file
	res                             = True
	res@txFont                      = 25
    res@gsnDraw                     = False
    res@gsnFrame                    = False
	res@vpWidthF                    = 0.2            ; Change the aspect ratio, but 
    res@vpHeightF                   = 0.2  
	res@gsnLeftString               = ""
    res@gsnRightString              = ""
	cmap  = read_colormap_file("WhiteBlueGreenYellowRed")
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
	res@gsnLeftStringFontHeightF   = 0.01
	res@tmXBLabelFontHeightF        = 0.01
    res@tmXTLabelFontHeightF        = 0.01
    res@tmYLLabelFontHeightF        = 0.01
	res@lbTitleFontHeightF          = 0.01
	res@lbLabelFontHeightF          = 0.01
	res@tmYLMode               = "Explicit"
	res@tmYLValues        		= ispan(0,14,2)
    res@tmYLLabels       		= (/"0","2","4","6","8","10","12","14"/)
	res@lbTitlePosition            = "bottom"
    res@tiXAxisString    = ""
	res@cnLevelSelectionMode = "ManualLevels" ; Set manual contour levels
	
	res7                  = res
	;res7@lbOrientation = "Vertical"
	res7@cnFillPalette   = cmap2	
	res7@cnMinLevelValF       = -0.5
	res7@cnMaxLevelValF       = 0.5
	res7@cnLevelSpacingF      = 0.01
	res7@cnFillMode            = "RasterFill"
	res7@cnRasterSmoothingOn   = True
	res7@lbBoxLinesOn          = False 
	res7@lbLabelStride         = 10
	res7@lbTitleString         = "~F8~D~F25~IWC (g~F34~W~F25~kg~S~-1~N~)"
	res7@trYMinF               = 0  
    res7@trYMaxF               = 12  
	
	; res@cnFillPalette    = cmap	
	; res@trXMinF          = 24  ; You could also just use
    ; res@trXMaxF          = 72   ; min/max of u0,u1,u2.
	
    ; res@tmXBValues       = ispan(24,72,24)
    ; res@tmXBLabels       = (/"24 h","48 h","72 h"/)
	; res@trYMinF          = 0  ; You could also just use
    ; res@trYMaxF          = 12   ; min/max of u0,u1,u2.	
	res1    = res7
	res1@tiYAxisString    		   = "~F25~Height (km)"
	res1@cnMinLevelValF       = -5
	res1@cnMaxLevelValF       = 5
	res1@cnLevelSpacingF      = 0.1
	; res1@cnLevelSelectionMode = "ManualLevels"
	res1@lbTitleString   = "~F25~CCN (ug~F34~W~F25~kg~S~-1~N~)"
	;res1@lbOrientation = "Vertical"


	;hydromass   = hydrometor({exam|:},{lev|:},{time|:})



	plot(1) = gsn_csm_contour(wks,plot_iwc,res7) 
    ;plot(1) = gsn_csm_contour(wks,plot_iwc2,res7) 
		
	plot(0) =  gsn_csm_contour(wks,plot_ccn,res1)
	;plot(3) =  gsn_csm_contour(wks,plot_ccn2,res1)
		
		
		
	

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
   ; gsn_panel(wks,(/plot(2),plot(5),plot(8)/),(/3,1/),resP)               ; now draw as one plot
    gsn_panel(wks,plot,(/1,2/),resP) 
  
end


