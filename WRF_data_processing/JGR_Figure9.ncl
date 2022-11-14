begin

;   filename 
	dir      = "data/"
	filename = (/"amz_data.nc","amz_data_CTL-1.nc"/)
	plotType = "pdf"       ; send graphics to PNG file
    plotName = "picture/nolin1"
    f       			 = addfiles(dir+filename,"r")      

;   read and process data  
	
	
	avo                     = dim_avg_n(f[0]->amz_avo(:,6:14,:,:),1)
	rh                      = dim_avg_n(f[0]->amz_rh(:,6:14,:,:),1)
	ctl_avo              	= dim_avg_n(f[1]->amz_avo(:,8:15,:,:),1)
	ctl_rh                  = dim_avg_n(f[1]->amz_rh(:,8:15,:,:),1)	

                    
	
	ARI_avo                 = avo(0,:,:) - ctl_avo(1,:,:)
	ACI_avo                 = avo(1,:,:) - ctl_avo(1,:,:)
	nolin_avo               = avo(2,:,:) + ctl_avo(1,:,:)-avo(0,:,:)-avo(1,:,:)
	ARI_rh                  = rh(0,:,:)  - ctl_rh(1,:,:)
	ACI_rh                  = rh(1,:,:)  - ctl_rh(1,:,:)
	ARI_dbz                 = dbz(0,:,:) - ctl_dbz(1,:,:)
	ACI_dbz                 = dbz(1,:,:) - ctl_dbz(1,:,:)
	
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
	copy_VarCoords(ARI_avo,nolin_avo)
	copy_VarCoords(ARI_avo,ACI_rh)
	copy_VarCoords(ARI_avo,ARI_rh)
	copy_VarCoords(rh,avo)
	
	; ctl_rh!1           = "lev"
	; ctl_rh!2           = "r"
	; ctl_rh&lev         = lev
	; ctl_rh&r           = ridus
	; copy_VarCoords(dbz_avg,plot_rh)
    ; copy_VarCoords(dbz_avg,plot_dbz)
	; printVarSummary(dbz_avg)
	; printVarSummary(plot_avo)

	; ; copy_VarCoords(dbz_avg,delt_rh)

	u             = dim_avg_n(f[0]->amz_u(:,8:15,:,:,:),1)
    v             = dim_avg_n(f[0]->amz_v(:,8:15,:,:,:),1)
	ctl_u         = dim_avg_n(f[1]->amz_u(:,8:15,:,:,:),1)
    ctl_v         = dim_avg_n(f[1]->amz_v(:,8:15,:,:,:),1)	

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
	
	ARI_v           = avg_u(0,:,:) - avg_ctl_u(1,:,:)
	ACI_v           = avg_u(1,:,:) - avg_ctl_u(1,:,:)
	nolin_v         = avg_u(2,:,:) + avg_ctl_u(1,:,:) - avg_u(0,:,:) - avg_u(1,:,:)
	copy_VarCoords(ARI_avo,ACI_v)
	copy_VarCoords(ARI_avo,ARI_v)
	copy_VarCoords(ARI_avo,nolin_v)
	copy_VarCoords(rh,avg_u)
	
	printVarSummary(ARI_avo)
	printVarSummary(ARI_v)
	
	; printVarSummary(avg_radial_u)
	; printMinMax(avg_radial_u,-1)
	
	
	
	; ;;;;;;;;;;;;;
	; plot part
	; ;;;;;;;;;;;;;
	
	uplot = new(6,"graphic")
    plot = new(6,"graphic")
    wks  = gsn_open_wks(plotType,plotName) ; send graphics to PNG file
	colors                = (/"grey35","salmon","royalblue1"/)
	res                             = True
	res@txFont                      = 25
    res@gsnDraw                     = False
    res@gsnFrame                    = False
	res@vpWidthF                    = 0.3           ; Change the aspect ratio, 
    res@vpHeightF                   = 0.3  
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
	res@tiYAxisFontHeightF         = 0.014
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
	res@cnMaxLevelValF         = 40
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
	res4@cnLineDashSegLenF      = 0.2
	res4@cnLineLabelInterval    = 1	
	res8                        = res4
	res4@cnLineDashPattern      = 0
	res4@cnLevels               = (/10,20,30/)	

	res8@cnLevels               = (/-10,10/)	
	; res8@cnLineDashPatterns      = 0
	; res8@cnMonoLineDashPattern   = False
    res8@cnLineLabelFontHeightF = 0.012

	
	;uplot(0)                    = gsn_csm_contour(wks,dbz_avg(0,:,:),res)
	plot(0)                      = gsn_csm_contour(wks,rh(2,:,:),res1)
	uplot(3)                    = gsn_csm_contour(wks,avo(2,:,:),res4)
	plot(3)                      = gsn_csm_contour(wks,avg_u(2,:,:),res2)
	; overlay(plot(0),uplot(0))
	overlay(plot(3),uplot(3))
	
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
	
	res6@cnMinLevelValF         = -1.5
	res6@cnMaxLevelValF         = 1.5
	res6@cnLevelSpacingF        = 0.03
	
	res5@cnMinLevelValF         = -10
	res5@cnMaxLevelValF         = 10
	res5@cnLevelSpacingF        = 0.2


	plot(1)              = gsn_csm_contour(wks,ARI_rh,res5)
	plot(2)              = gsn_csm_contour(wks,ACI_rh,res5)
	
	plot(4)              = gsn_csm_contour(wks,nolin_v,res6)
	plot(5)              = gsn_csm_contour(wks,ACI_v,res6)	
	
	uplot(0)             = gsn_csm_contour(wks,nolin_v,res7)
	uplot(1)             = gsn_csm_contour(wks,ACI_v,res7)

	overlay(plot(4),uplot(0))
	overlay(plot(5),uplot(1))
	
	
	avoplot            = gsn_csm_contour(wks,nolin_avo,res8)
	avoplot2           = gsn_csm_contour(wks,ACI_avo,res8)
	overlay(plot(4),avoplot)
	overlay(plot(5),avoplot2)
		
	; charL                       = (/"(a) CLEAN","(b) ARI","(c) ACI","(d) CLEAN","(e) ARI"\
									; ,"(f) ACI"/)
	; legend                      = new(9,graphic)
	; legend2                     = new(3,graphic)
	; resT                             = True
	; resT@txFont        = 25 
    ; resT@txFontHeightF = 0.014
    ; resT@txFontColor = "black"
    ; resT@txJust = "BottomLeft"
	; resT@txFontThicknessF = 2.0
	; do i=0,dimsizes(charL)-1
		; legend(i)                = gsn_add_text(wks,plot(i),charL(i),10.0,12.5,resT)
	; end do

  ; profile_u                      = dim_avg_n_Wrap(avg_radial_u,2)
  ; profile_avo                    = dim_avg_n_Wrap(avo,2)
  ; profile_dbz                    = dim_avg_n_Wrap(dbz_avg,2)
  ; profile_rh                     = dim_avg_n_Wrap(rh,2)
  ; delt_rh           = new(dimsizes(profile_rh),float,0)
  ; delt_u            = new(dimsizes(profile_u),float,0)
  ; printVarSummary(profile_rh)
  ; delt_rh(0,:)  = profile_rh(2,:) - profile_rh(0,:)
  ; delt_rh(1,:)  = profile_rh(1,:) - profile_rh(0,:)
  ; delt_u(0,:)   = profile_u(2,:) - profile_u(0,:)
  ; delt_u(1,:)   = profile_u(1,:) - profile_u(0,:)  
  ; printVarSummary(profile_u)
  ; printVarSummary(profile_rh)
	; colors                = (/"grey35","salmon","royalblue1"/)
   ; xyres                        =  True
   ; xyres@gsnDraw                =  False            ;-- don't draw yet
   ; xyres@gsnFrame               =  False            ;-- don't advance frame yet
   ; xyres@tmYUseLeft             =  False
   ; ; xyres@tmYLMode               = "Explicit"
   ; ; xyres@tmYLValues             =  lev
   ; ; xyres@tmYLMinorOn            =  False            ;-- no minor tick marks
   ; xyres@xyLineThicknessF       =  2.0                ;-- line thickness
   ; xyres@xyLineColors           = colors
   ; xyres@xyDashPatterns         = (/0,0,0/)
   ; xyres@trYMinF                =  0
   ; xyres@trYMaxF                =  14
   ; xyres@vpWidthF               =  0.14             ;-- set width
   ; xyres@vpHeightF              =  0.3 
   ; xyres@tmXBLabelFont          = 25
   ; xyres@tmXBLabelFontHeightF        = 0.012
   ; xyres@tmXTLabelFontHeightF        = 0.012
   ; xyres@tmYLLabelFontHeightF        = 0.012
   ; xyres2                       = xyres
   ; xyres4                       = xyres
   ; ;xyres4@xyDashPatterns      = (/2,2,2/)
   ; xyres2@xyLineColors           = (/"royalblue1","salmon","black"/)
   ; xyres4@xyLineColor           = "red"
   ; xyres@tmYRLabelsOn           =  True
   ; xyres@tmYRMode               = "Explicit"
   ; xyres@tmYRValues             =  ispan(0,14,1)
   ; xyres@tmYROn                 =  True
   ; xyres@tmYRBorderOn           =  True
   ; xyres@tmXBMode                 = "Explicit"
   ; xyres@tmXBValues        		= ispan(-3,3,1)
   ; xyres@tmXBLabels       		= (/"-3","-2","-1","0","1","2","3"/)
   ; xyres@tiXAxisString           = ""
   ; xyres2@tiXAxisString          = ""
   ; xyres4@tiXAxisString          = ""
   ; xyres@tmYRLabelFontHeightF   =  0.004
   ; xyres@tmYLLabelFontHeightF   =  0.006
   ; xyres@tmYLMajorLengthF       =  0.006            ;-- change the tickmark length
   ; xyres@tmXTOn                 =  True
   ; xyres@tmXBOn                 =  True
   ; xyres@tmXBMinorOn            =  False            ;-- no minor tickmarks
   ; xyres@trXMinF                =  -3
   ; xyres@trXMaxF                =  3
   ; xyres2@trXMinF                =  -20
   ; xyres2@trXMaxF                =  20
   ; xyres2@gsnXRefLine             = 0      ; four X reference lines
   ; xyres2@gsnXRefLineDashPatterns = 2
   ; xyres2@gsnXRefLineThicknessF   = 2.5
   ; xyres3                        = xyres2
   ; xyres2@tmXTMode             = "Explicit"
   ; xyres2@tmXTValues           = ispan(0,30,10)
   ; xyres2@tmXTLabels       	  = (/"0","10","20","30"/)
	; xyres3@trXMinF                =  -1
    ; xyres3@trXMaxF                =  2
	; xyres3@tmXTMode                 = "Explicit"
    ; xyres3@tmXTValues        		= ispan(-1,2,1)
    ; xyres3@tmXTLabels       		= (/"-1","0","1","2"/)
   	; pro_plot = new(2,"graphic")
	; pro_plot(0) = gsn_csm_x2y(wks, profile_u(0,:), delt_u(:1,:),lev, xyres,xyres3)
	; pro_plot(1) = gsn_csm_x2y(wks, profile_rh(0,:),delt_rh(:1,:),lev, xyres4,xyres2)
	; legend1                = gsn_add_text(wks,pro_plot(1),"(g)",7.0,12.5,resT)
    ; legend2                = gsn_add_text(wks,pro_plot(0),"(h)",-2.7,12.5,resT)


    resP                     = True                ; modify the panel plot
	resP@gsnPanelTop         = 0.9
	resP@gsnPanelBottom      = 0.05

  gsn_panel(wks,plot,(/2,3/),resP)

end


