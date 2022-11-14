begin

    ;; file name and direction
	dir      = "data/"
	filename = (/"matter.nc","hydro.nc","ctl_matter.nc","ctl_hydro2.nc","amz_data.nc","amz_data_CTL-2.nc"/)
	plotType  = "pdf"       ; send graphics to PNG file
    plotName  = "picture/Figure3-t2-ctl"

	;; read and process data
    f          = addfiles(dir+filename,"r")  
	; u          = dim_avg_n(f[4]->amz_u(:,6:14,:,:,:),1)
    ; v          = dim_avg_n(f[4]->amz_v(:,6:14,:,:,:),1)
;	avo        = dim_avg_n(f[4]->amz_avo(:,6:14,:,:),1)
	

	ctl_u          = dim_avg_n(f[5]->amz_u(:,6:14,:,:,:),1)
    ctl_v          = dim_avg_n(f[5]->amz_v(:,6:14,:,:,:),1)

	
	;tangen_u      = new(dimsizes(u),float,0)
	ctl_tangen_u  = new(dimsizes(ctl_u),float,0)
	
	do i=0,359
		theta                    = i*3.14159265/180
		;tangen_u(:,:,:,i)        = v(:,:,:,i)*cos(theta)-u(:,:,:,i)*sin(theta)
		ctl_tangen_u(:,:,:,i)    = ctl_v(:,:,:,i)*cos(theta)-ctl_u(:,:,:,i)*sin(theta)
	end do
	; avg_u               = dim_avg_n_Wrap(tangen_u,3)
	; rmw                 = new((/3,40/),float,0)
	ctl_avg_u             = dim_avg_n_Wrap(ctl_tangen_u,3)
	ctl_rmw               = new((/2,40/),float,0)	
	
	
	;printVarSummary(avg_u)
	; do nf=0,2
		; do i=0,39
			; rmw(nf,i) = 3*maxind(avg_u(nf,i,:))
			
		; end do
	; end do
	do nf=0,1
		do i=0,39
			ctl_rmw(nf,i) = 3*maxind(ctl_avg_u(nf,i,:))
		end do
	end do	
	
	;printVarSummary(rmw)
    

	; iwc                 = 1000*(dim_avg_n(f[1]->iwc(:,6:14,:,:),1))
	; lwc                 = 1000*(dim_avg_n(f[1]->lwc(:,6:14,:,:),1))
	; swc                 = 1000*(dim_avg_n(f[1]->swc(:,6:14,:,:),1))	
	; gwc                 = 1000*(dim_avg_n(f[1]->gwc(:,6:14,:,:),1))
	
	ctl_iwc                 = 1000*(dim_avg_n(f[3]->iwc(:,6:14,:,:),1))
	ctl_lwc                 = 1000*(dim_avg_n(f[3]->lwc(:,6:14,:,:),1))
	ctl_swc                 = 1000*(dim_avg_n(f[3]->swc(:,6:14,:,:),1))	
	ctl_gwc                 = 1000*(dim_avg_n(f[3]->gwc(:,6:14,:,:),1))
	
	;iwc                 = iwc+swc+gwc
	ctl_iwc             = ctl_iwc+ctl_gwc+ctl_swc
	
	; ARI_iwc    		    = iwc(0,:,:) - ctl_iwc(0,:,:)
	; ACI_iwc     		= iwc(1,:,:) - ctl_iwc(0,:,:)
	; Total_iwc           = iwc(2,:,:) - ctl_iwc(0,:,:)
	; ARI_lwc   		    = lwc(0,:,:) - ctl_lwc(1,:,:)
	; ACI_lwc     		= lwc(1,:,:) - ctl_lwc(1,:,:)	
	
	; printVarSummary(iwc)
	; iwc_t                 = 1000*(dim_avg_n(f[1]->iwc(:,:,:,:67),3))
	; lwc_t                 = 1000*(dim_avg_n(f[1]->lwc(:,:,:,:67),3))
	; swc_t                 = 1000*(dim_avg_n(f[1]->swc(:,:,:,:67),3))	
	; gwc_t                 = 1000*(dim_avg_n(f[1]->gwc(:,:,:,:67),3))	
	; hydrometor            = iwc_t+lwc_t+swc_t+gwc_t
	
	ctl_iwc_t                 = 1000*(dim_avg_n(f[3]->iwc(:,:,:,:67),3))
	ctl_lwc_t                 = 1000*(dim_avg_n(f[3]->lwc(:,:,:,:67),3))
	ctl_swc_t                 = 1000*(dim_avg_n(f[3]->swc(:,:,:,:67),3))	
	ctl_gwc_t                 = 1000*(dim_avg_n(f[3]->gwc(:,:,:,:67),3))	
	ctl_hydrometor            = ctl_iwc_t+ctl_lwc_t+ctl_swc_t+ctl_gwc_t
	
	
	; printVarSummary(hydrometor)
	; rw                  = 10^5*dim_avg_n(f[0]->amz_rw(:,:,:,:),3)
	; mw                  = 10^3*dim_avg_n(f[0]->amz_mw(:,:,:,:),3)
	; div                 = -1*10^5*dim_avg_n(f[0]->amz_div(:,:,:,:),3)
	
	ctl_rw                  = 10^5*dim_avg_n(f[2]->amz_rw(:,:,:,:),3)
	ctl_mw                  = 10^3*dim_avg_n(f[2]->amz_mw(:,:,:,:),3)
	ctl_div                 = -1*10^5*dim_avg_n(f[2]->amz_div(:,:,:,:),3)
	printVarSummary(ctl_div)
	lev                = fspan(0.1,14,40)
	time               = ispan(24,72,3)
	exam               = ispan(0,1,1)
	ctl_rw!0                = "exam"
	ctl_rw!1                = "time"
	ctl_rw!2                = "lev"
	ctl_rw&exam             = exam
	ctl_rw&lev              = lev
	ctl_rw&time             = time
	
	ridus               = ispan(0,300,3)

	; ctl_iwc!1               = "lev"
	; ctl_iwc!2               = "r"
	; ctl_iwc&lev             = lev
	; ctl_iwc&r               = ridus

	ctl_iwc!1               = "lev"
	ctl_iwc!2               = "r"
	ctl_iwc&lev             = lev
	ctl_iwc&r               = ridus	

	; lwc!1               = "lev"
	; lwc!2               = "r"
	; lwc&lev             = lev
	; lwc&r               = ridus	
	
	copy_VarCoords(ctl_rw,ctl_mw)
	copy_VarCoords(ctl_rw,ctl_div)
	copy_VarCoords(ctl_iwc,ctl_lwc)
	; copy_VarCoords(ARI_iwc,ACI_iwc)
	; copy_VarCoords(ARI_iwc,Total_iwc)
	; copy_VarCoords(ARI_iwc,ACI_lwc)
	; copy_VarCoords(ARI_iwc,ARI_lwc)
	; copy_VarCoords(ARI_iwc,ctl_iwc(0,:,:))
	copy_VarCoords(ctl_rw,ctl_hydrometor)
	;copy_VarCoords(rw(0,:,:),ctl_hydrometor(0,:,:))
	printVarSummary(ctl_div)
	printVarSummary(ctl_rw)
	; printVarSummary(mw)
    ; printVarSummary(hydrometor)
	; printMinMax(ARI_iwc,-1)
	; printMinMax(rw,-1)
;;;;;;;;;;;;;;;;;;;
;;   plot part   
;;;;;;;;;;;;;;;;;;;

    plot = new(12,"graphic")
	cov_plot = new(4,"graphic")
	rmw_plot = new(4,"graphic")
	hydro_plot = new(4,"graphic")
	lwc_plot   = new(4,"graphic")
	
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
	res@lbLabelBarOn                = True
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
	res@tiYAxisFontHeightF         = 0.014
	res@tiXAxisFontHeightF         = 0.014
	res@tmYLMode               = "Explicit"
	res@tmYLValues        		= ispan(0,14,2)
    res@tmYLLabels       		= (/"0","2","4","6","8","10","12","14"/)
	res@lbTitlePosition            = "bottom"
    res@tiXAxisString    = ""
	res@cnLevelSelectionMode = "ManualLevels" ; Set manual contour levels
	
	res7                  = res
	res7@lbOrientation = "Vertical"
	res7@cnFillPalette   = cmap2	
	res7@cnMinLevelValF       = -0.1
	res7@cnMaxLevelValF       = 0.1
	res7@cnLevelSpacingF      = 0.01
	res7@cnFillMode            = "RasterFill"
	res7@cnRasterSmoothingOn   = True
	res7@lbBoxLinesOn          = False 
	res7@lbLabelStride         = 10
	res7@lbTitleString         = "~F8~D~F25~IWC (g~F34~W~F25~kg~S~-1~N~)"
	res7@trYMinF               = 0  
    res7@trYMaxF               = 12  
	
	res@cnFillPalette    = cmap	
	res4                 = res
	
	res6                 = res
	res4@cnFillPalette    := cmap	
	res@trXMinF          = 24  ; You could also just use
    res@trXMaxF          = 72   ; min/max of u0,u1,u2.
	res@tmXBMode         = "Explicit"
    res@tmXBValues       = ispan(24,72,24)
    res@tmXBLabels       = (/"24 h","48 h","72 h"/)
	res@trYMinF          = 0  ; You could also just use
    res@trYMaxF          = 12   ; min/max of u0,u1,u2.	
	res1    = res
	res1@tiYAxisString    		   = "~F25~Height (km)"
	res1@cnMinLevelValF       = 0
	res1@cnMaxLevelValF       = 120
	res1@cnLevelSpacingF      = 10
	res2    = res1
	res3    = res
	res3@cnFillOn                    = False
	res3@cnLineThicknessF            = 2
	res3@cnLinesOn                   = True
	res3@cnLineLabelsOn    		     = True
	res3@cnLineLabelFont             = 25
	res3@cnLineLabelFontHeightF      = 0.01
	res3@cnLineLabelPlacementMode    = "Constant"
	res3@cnLevelSelectionMode        = "ExplicitLevels"
	res5     = res3
	res3@cnLevels                    = (/2,4/)
	res3@cnLineDashSegLenF           = 0.06
	res3@cnLineLabelInterval         = 1
	res3@trYMinF                     = 0  ; You could also just use
    res3@trYMaxF          = 4   ; min/max of u0,u1,u2.	
	res5@cnLevels                    = (/0.4,0.6,0.8/)
	res5@cnLineDashSegLenF           = 0.1
	res5@cnLineLabelInterval         = 1
	res5@cnLineColor                = "maroon3";"darkorange1";"lightsalmon"
	res5@cnLineDashSegLenF          = 0.15
	res5@cnExplicitLineLabelsOn     = True
	res5@cnLineLabelStrings         = (/"0.4","0.6","0.8"/)
	res5@cnSmoothingOn              = True
	res6@cnFillOn                    = False
	res6@cnLineThicknessF            = 2
	res6@cnLinesOn                   = True
	res6@cnLineLabelsOn    		     = True
	res6@cnLineLabelFont             = 25
	res6@cnLineLabelFontHeightF      = 0.01
	res6@cnLineLabelPlacementMode    = "Constant"
	res6@cnLevelSelectionMode        = "ExplicitLevels"
	res6@cnLineDashSegLenF          = 0.12
	res6@cnLineLabelInterval         = 1
	res6@cnExplicitLineLabelsOn     = True
	res8                             = res6
	res6@cnLevels                    = (/0.15/)
	res6@cnLineDashSegLenF           = 0.1
	res6@cnLineThicknessF            = 3
	res6@cnLineDashPattern          = 0
	res6@cnLineColor                = "gray"
	res6@cnLineLabelStrings         = (/"0.1"/)
    res6@cnLineLabelsOn    		     = False
	res8@cnLineThicknessF            = 2
	res8@cnLineLabelPlacementMode = "Constant"
	res8@cnLevelSelectionMode   = "ExplicitLevels"
	res8@cnLevels                    = (/-0.2,-0.1,0.05,0.2/)
	res8@cnLineLabelsOn              = False
	res8@cnLineDashPatterns          = (/2,2,0,0/)
	res8@cnMonoLineDashPattern   = False
	res8@cnLineColor                = "black"
	res4@cnLevelSelectionMode   = "ManualLevels" ; Set manual contour levels
	res4@cnMinLevelValF         = 0.1
	res4@cnMaxLevelValF         = 1
	res4@cnLevelSpacingF        = 0.01
	res4@cnFillMode             = "RasterFill"
	res4@cnRasterSmoothingOn    = True
	res4@lbBoxLinesOn          = False 
	res4@lbLabelStride           = 10	
	res4@trYMinF              = 0  
    res4@trYMaxF              = 12  


	res1@lbTitleString   = "~F25~Vertical Mass Flux (g~F34~W~F25~m~S~-2~N~s~S~-1~N~)"
	res2@lbTitleString   = "~F25~Vertical Moisture Flux (10~S~-2~N~g~F34~W~F25~m~S~-2~N~s~S~-1~N~)"
	res4@lbTitleString   = "~F25~IWC (g~F34~W~F25~kg~S~-1~N~)"

	ctl_mw1         = ctl_mw({exam|:},{lev|:},{time|:})
	ctl_rw1         = ctl_rw({exam|:},{lev|:},{time|:})
	ctl_div1        = ctl_div({exam|:},{lev|:},{time|:})
	ctl_hydromass   = ctl_hydrometor({exam|:},{lev|:},{time|:})
	ctl_mw1@_FillValue                 = -999
	ctl_rw1@_FillValue                 = -999
	ctl_div1@_FillValue                = -999

	printVarSummary(ctl_mw1)
	res1@lbLabelBarOn                = False
	res2@lbLabelBarOn                = False
	;res4@lbLabelBarOn                = False
	res4@tiYAxisString    		   = "~F25~Height (km)"
	res4@tiXAxisString    		   = "~F25~Radius (km)"
	
	;print(ctl_iwc(1,:,:))
	plot(2)       = gsn_csm_contour(wks,ctl_iwc(0,:,:),res4) 
	lwc_plot(0)   = gsn_csm_contour(wks,ctl_lwc(0,:,:),res6) 
	overlay(plot(2),lwc_plot(0))

	; plot(5) 	  = gsn_csm_contour(wks,ACI_iwc,res4) 
	; lwc_plot(1)   = gsn_csm_contour(wks,lwc(1,:,:),res6) 
	; overlay(plot(5),lwc_plot(1))
	
	; res4@lbLabelBarOn         = True
	; res4@lbOrientation = "Vertical"
	 ; plot(8)	  = gsn_csm_contour(wks,Total_iwc,res4) 
	; lwc_plot(2)   = gsn_csm_contour(wks,lwc(2,:,:),res6) 
	;overlay(plot(8),lwc_plot(2))
		

	;res7@lbLabelBarOn                = False

	;do i = 0,2
		; if(i.eq.2) then		
		res1@lbLabelBarOn                = True
		res2@lbLabelBarOn                = True
		; end if
		; plot(i*3)     = gsn_csm_contour(wks,mw1(i,:,:),res1) 
		; plot(i*3+1)   = gsn_csm_contour(wks,rw1(i,:,:),res2) 
		; cov_plot(i)   = gsn_csm_contour(wks,div1(i,:,:),res3) 
		; hydro_plot(i) = gsn_csm_contour(wks,hydromass(i,:,:),res5) 
		; overlay(plot(i*3),cov_plot(i))
		; overlay(plot(i*3+1),hydro_plot(i))
		
		
		plot(0)     = gsn_csm_contour(wks,ctl_mw1(0,:,:),res1) 
		plot(1)   = gsn_csm_contour(wks,ctl_rw1(0,:,:),res2) 
		cov_plot(0)   = gsn_csm_contour(wks,ctl_div1(0,:,:),res3) 
		hydro_plot(0) = gsn_csm_contour(wks,ctl_hydromass(0,:,:),res5) 
		overlay(plot(0),cov_plot(0))
		overlay(plot(1),hydro_plot(0))
	;end do


	;p_line               = new(4, graphic)
	resLine                   = True
	resLine@gsLineColor       = "black" 
	resLine@gsLineDashPattern = 2
	resLine@gsLineThicknessF  = 3
	; do j=0,1
		; p_line(j*2)        = gsn_add_polyline(wks,plot(j+3),(/64,64/),\
							; (/0,12/),resLine)  		
		; p_line(j*2+1)        = gsn_add_polyline(wks,plot(j+6),(/56,56/),\
							; (/0,12/),resLine)  								
    ; end do
    resLine@gsLineThicknessF  = 3
	resLine@gsLineDashPattern = 0
	resLine@gsLineColor   = "blue4"
	rmw_line0            = gsn_add_polyline(wks,plot(2),ctl_rmw(0,:27),\
									lev(:27),resLine)  
	; rmw_line1            = gsn_add_polyline(wks,plot(5),rmw(2,:27),\
									; lev(:27),resLine)  	
	; rmw_line2            = gsn_add_polyline(wks,plot(8),rmw(1,:27),\
									; lev(:27),resLine)  
    resP                     = True                ; modify the panel plot
	resP@gsnMaximize         = True
	resP@gsnPanelTop         = 0.98
	resP@gsnPanelBottom      = 0.05
	resP@gsnPanelLeft        = 0.05
   ;gsn_panel(wks,(/plot(2),plot(5),plot(8)/),(/1,3/),resP)               ; now draw as one plot
    gsn_panel(wks,plot(0:2),(/1,3/),resP) 
  
end


