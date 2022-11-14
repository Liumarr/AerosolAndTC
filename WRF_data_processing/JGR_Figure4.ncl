begin

;   file name
	filename = (/"data/MICRO_envir.nc"/)
	plotType = "pdf"       ; send graphics to PNG file
    plotName = "picture/sound"

;   read data
    f       		  = addfile(filename,"r")      
	phy               = f->t
	printVarSummary(phy)
	lwc                = dim_avg_n(phy(7,:,8:,:),1)
	iwc                = dim_avg_n(phy(8,:,8:,:),1)
	th                 = dim_avg_n(phy(0,:,8:,:),1)
	w                  = dim_avg_n(phy(6,:,8:,:),1)
	lw                 = dim_avg_n(phy(5,:,8:,:),1)
	sw                 = dim_avg_n(phy(4,:,8:,:),1)
	lt                 = dim_avg_n(phy(3,:,8:,:),1)
	cf                 = dim_avg_n(phy(2,:,8:,:),1)
	rad                = (/sw(0,:),sw(1,:)\
	,lw(0,:),lw(1,:)/)
	net                = lw+sw+lt
	hydro_mass         = iwc+lwc
	printVarSummary(hydro_mass)
	printMinMax(hydro_mass,-1)
	printMinMax(w,-1)
	print(cf)
	lev                  = fspan(0,12,40)
	th!1                = "lev"
	th&lev              = lev
	copy_VarCoords(th,lt)
	copy_VarCoords(th,w)
	copy_VarCoords(th,sw)
	copy_VarCoords(th,lw)
	copy_VarCoords(th,cf)
	copy_VarCoords(th,net)
	printVarSummary(w)
	delt_th            = new((/2,40/),float,0)
	delt_th(0,:)            = th(0,:)-th(1,:)
	;delt_th(1,:)            = th(2,:)-th(0,:)
	copy_VarCoords(th,delt_th)
	;;;;;;;;;;;;;;;;;;;;
	;; plot part
	;;;;;;;;;;;;;;;;;;;;

    plot  = new(6,"graphic")
    wks  = gsn_open_wks(plotType,plotName) ; send graphics to PNG file
	colors                = (/"springgreen3","royalblue1"/)
	res                             = True
	res@txFont                      = 25
    res@gsnDraw                     = False
    res@gsnFrame                    = False
	res@vpWidthF                    = 0.25            ; Change the aspect ratio, but 
    res@vpHeightF                   = 0.25  
	res@gsnLeftString               = ""
    res@gsnRightString              = ""
	res@tmXBMajorOutwardLengthF    = -0.001
	res@tmXBMinorOutwardLengthF    = -0.001
    res@tmYLMajorOutwardLengthF    = -0.001
    res@tmYLMinorOutwardLengthF    = -0.001
    res@tmYRMajorOutwardLengthF    = -0.001
    res@tmYRMinorOutwardLengthF    = -0.001
	;res@gsnLeftStringFontHeightF   = 0.01
	res@tmXBLabelFontHeightF        = 0.012
    res@tmXTLabelFontHeightF        = 0.012
    res@tmYLLabelFontHeightF        = 0.012
	res@tmYLMode               = "Explicit"
	res@tmYLValues        		= ispan(0,4,1)
    res@tmYLLabels       		= (/"0","1","2","3","4"/)
	
	res@tiYAxisString    		   = "~F25~Height (km)"
	res@tiXAxisFontHeightF         = 0.012
	res@tiYAxisFontHeightF         = 0.012
	res@trYMinF         		   = 0  ; You could also just use
    res@trYMaxF         		   = 4  ; min/max of u0,u1,u2.
    res@tiXAxisString    = ""
    res@xyLineThicknessF = 2.5
	res@xyDashPatterns    = (/0,0,0/)
	res2    = res
	res@xyLineColors     = colors
	; res@trXMinF          = 0  ; You could also just use
    ; res@trXMaxF          = 48   ; min/max of u0,u1,u2.
	
	res1    = res
	res3    = res
	resD    = res
	res4    = res
	res5    = res

	res@xyDashPatterns    = (/0,0,0/)
	resD@xyDashPatterns   = (/0,0,0/)
	resD@xyLineColors     = (/"black","royalblue1"/)
	resD@trXMinF          = -1.2
	resD@trXMaxF          = 1.2
	resD@tiXAxisString    = "~F8~q~F25~(K)"
	resD@gsnXRefLine      = 0
	resD@gsnXRefLineThicknessF = 2
	resD@gsnXRefLineDashPattern = 2


	
	res@trXMinF          = 300
	res@trXMaxF          = 320
	res@tmXTMode         = "Manual"
    res@tmXTTickStartF       = 300
	res@tmXTTickEndF         = 320
	res@tmXTTickSpacingF     = 5
	res@tiXAxisString     = "~F25~Potential Temperature (K)"
	resD@tiXAxisString    = "~F8~Dq~F25~ (K)"
	plot(0) = gsn_csm_x2y(wks,delt_th,th(0,:),th&lev,resD,res) 

	res1@tiXAxisString     = "~F25~Vertical Velocity (mm/s)"	
	res1@trXMinF          = -10
	res1@trXMaxF          = 10
    res1@tmXBMode         = "Manual"
    res1@tmXBTickStartF       = -10
	res1@tmXBTickEndF         = 10
	res1@tmXBTickSpacingF     = 5
	res1@gsnXRefLine      = 0
	res1@gsnXRefLineThicknessF = 2
	res1@gsnXRefLineDashPattern = 2
	plot(5) = gsn_csm_xy(wks,w,w&lev,res1) 
	
	res2@xyLineColors     = (/"springgreen3","royalblue1","springgreen3","royalblue1"/)
	res2@gsnLeftStringFontHeightF = 0.01
	res2@gsnRightStringFontHeightF = 0.01
	res2@gsnLeftString    = "Longwave"
	res2@gsnRightString    = "Shortwave"
	res2@tiXAxisString    = "~F25~Radiation Heating (K/Day)"	
	res2@trXMinF          = -4.6
	res2@trXMaxF          = 2

	res2@tmXBMode         = "Explicit"
    res2@tmXBValues       = ispan(-5,2,1)
	res2@tmXBLabels       = (/"-5","-4","-3","-2","-1","0","1","2"/)
	res2@gsnXRefLine      = 0
	res2@gsnXRefLineThicknessF = 2
	res2@gsnXRefLineDashPattern = 2
	
	res3@tmXBMode         = "Explicit"
	res3@tmXBValues       = ispan(-4,4,2)
	res3@tmXBLabels       = (/"-4","-2","0","2","4"/)
	res3@tiXAxisString    = "~F25~Latent Heating (K/Day)"
	res3@trXMinF          = -4
	res3@trXMaxF          = 4.6
    ;res3@tmXBMode         = "Manual"
    ; res3@tmXBTickStartF       = -4
	; res3@tmXBTickEndF         = 4
	; res3@tmXBTickSpacingF     = 2
	res3@gsnXRefLine      = 0
	res3@gsnXRefLineThicknessF = 2
	res3@gsnXRefLineDashPattern = 2
    ; res3@tmXBValues       = (/0,0.1,0.2,0.3,0.4,0.5/)
	; res3@tmXBLabels       = (/"0","0.1","0.2","0.3","0.4","0.5"/)
	; res3@tiXAxisString    = "~F25~Hydrometeor Mass (g/m-3)"
	
	
	res4@trXMinF          = 0
	res4@trXMaxF          = 0.3
	res4@tiXAxisString    = "~F25~Cloud Fraction"	
	res4@tmXBMode         = "Explicit"
    res4@tmXBValues       = (/0,0.1,0.2,0.3/)
	res4@tmXBLabels       = (/"0","0.1","0.2","0.3"/)



	res5@trXMinF          = -4
	res5@trXMaxF          = 4
	res5@tiXAxisString    = "~F25~Diabatic Heating (K/Day)"	
	res5@tmXBMode         = "Explicit"
    res5@tmXBValues       = ispan(-4,4,2)
	res5@tmXBLabels       = (/"-4","-2","0","2","4"/)
	res5@gsnXRefLine      = 0
	res5@gsnXRefLineThicknessF = 2
	res5@gsnXRefLineDashPattern = 2

	
	plot(3) = gsn_csm_xy(wks,lt,th&lev,res3) 
	plot(1) = gsn_csm_xy(wks,cf,cf&lev,res4)
	plot(2) = gsn_csm_xy(wks,rad,th&lev,res2)  
	plot(4) = gsn_csm_xy(wks,net,th&lev,res5) 



    resP                     = True                ; modify the panel plot
	resP@gsnMaximize         = True
	resP@gsnPanelTop         = 0.98
	resP@gsnPanelBottom      = 0.05
	resP@gsnPanelLeft        = 0.05

	
    txres               = True                     ; text mods desired
	txres@txFont        = 25
    txres@txFontHeightF = 0.016

	;drawNDCGrid(wks)  
    gsn_text_ndc(wks,"(a)",0.125,0.795,txres) 
    gsn_text_ndc(wks,"(b)",0.444,0.795,txres) 
    gsn_text_ndc(wks,"(c)",0.755,0.795,txres) 
    gsn_text_ndc(wks,"(d)",0.125,0.44,txres) 
    gsn_text_ndc(wks,"(e)",0.444,0.44,txres) 
    gsn_text_ndc(wks,"(f)",0.755,0.44,txres)   

   ;; adding dot

	gres = True
	gres@YPosPercent = 80.      ; expressed as %, 0->100, sets position of top border of legend                           ;  when gres@Position is set to its default setting of "Top" (Default = 95.)
	gres@XPosPercent = 5.      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
	lineres = True
	lineres@lgLineColors = (/"springgreen3","royalblue1"/) ; line colors
	lineres@lgLineThicknesses = 2.0                       ; line thicknesses
	lineres@LineLengthPercent = 9.                         ; expressed as %, 0->100, length of line
	textres = True
	textres@lgLabels = (/"~F25~CLD","~F25~RAD"/)  ; legend labels (required)
	textres@lgLabelFontHeights  = 0.01
	textres@lgAutoManage        = False
	legend = simple_legend(wks,plot(0),gres,lineres,textres)
    gsn_panel(wks,plot,(/2,3/),resP)               ; now draw as one plot



end


