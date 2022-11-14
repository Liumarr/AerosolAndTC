
;2022.11.14 mar


begin

;; file name and direction
	plotType = "pdf"       ; send graphics to PNG file
	plotName = "picture/Figure1-2"
	Dir  = "data/"

	name = (/"uv.nc","IBTrACS.last3years.v04r00.nc" /)
  name2= (/"RAD.txt","CLD.txt","CTL.txt","CLEAN.txt"/)
  
; read data; time interval is 3 hour wrfout

  f          = addfiles( Dir+name, "r" )
  v          = dim_avg_n_Wrap(f[0]->tangen_v,3)
	vmax       = new((/4,17/),float)

	printVarSummary(v)
  do i=0,4
		k = 0
    do j=0,16
        vmax(i,j) = max(v(i,j,:100))/0.51444
	  end do
  end do
	printVarSummary(vmax)
	;  compute radial wind 
  vmax_jtwc     = f[2]->usa_wind(154,0:14)  

  ;;;;;;;;;;;;;;;
  ;; plot part
  ;;;;;;;;;;;;;;;
  
  plot      = new(4,"graphic")
  wks = gsn_open_wks(plotType,plotName)
  colors                = (/"royalblue1","springgreen3","salmon","grey35"/)
  res                  = True 
  ;res@gsnMaximize      = True
  res@txFont           = 25
  res@vpWidthF         = 0.4            ; Change the aspect ratio, but 
  res@vpHeightF        = 0.4           ; make plot as large as possible.
  res@gsnPaperOrientation = "portrait"
  res@gsnDraw          = False
  res@gsnFrame         = False
  res@trXMinF          = 0  ; You could also just use
  res@trXMaxF          = 48   ; min/max of u0,u1,u2.
  res@tiXAxisString    = ""
  res@xyLineThicknessF = 4
  res@tmXBMode         = "Explicit"
  res@tmXBValues       = ispan(0,48,12)
  res@tmXBLabels       = (/"24","36","48","60","72"/)
  res@gsnRightString = ""
  res@gsnLeftString = ""
  res@tmXBMajorOutwardLengthF = -0.001
  res@tmXBMinorOutwardLengthF = -0.001
  res@tmYLMajorOutwardLengthF = -0.001
  res@tmYLMinorOutwardLengthF = -0.001
  res@tmYRMajorOutwardLengthF = -0.001
  res@tmYRMinorOutwardLengthF = -0.001
  res@tiYAxisFontHeightF = 0.014
  res@tiXAxisFontHeightF = 0.014
  res2                 = res
  reS4                 = res
  
  res@gsnYRefLine      = 34
  res@gsnYRefLineDashPatterns = 2
  res@gsnYRefLineThicknessF   = 2.5
  res@gsnYRefLineColor   = "grey35"
  res@xyLineColors     = colors
  res@xyDashPatterns    = (/0,0,0,0,16/)
  res3                 = res
  res3@trYMinF          = 990          ; Set min/max of right Y axis
  res3@trYMaxF          = 1010
  res3@tmYLMode         = "Explicit"
  res3@tmYLValues       = (/990,995,1000,1005,1010/)
  res3@tmYLLabels       = (/"990","995","1000","1005","1010"/)
  res3@tiYAxisString    = "~F25~SLP (hPa)"
  res3@tiXAxisString    = "~F25~Hour" 

 
  res@trYMinF          = 10          ; Set min/max of right Y axis
  res@trYMaxF          = 40
  res@tmYLMode         = "Explicit"
  res@tmYLValues       = (/10,20,30,34,40/)
  res@tmYLLabels       = (/"10","20","30","34","40"/)
  time = ispan(0,48,3)
  res@tiYAxisString    = "~F25~Intensity (knot)"
  res@tiXAxisString    = "~F25~Hour"
  res@tmYRFormat       = "f"            ; Remove trailing zeros from labels
  
  ; slp & location bias
  plot(0) = gsn_csm_xy(wks,time,vmax(:,:),res)
  plot(2) = gsn_csm_xy(wks,time,slp(:,:),res3)
  time2  = ispan(6,48,3)
  res2@xyLineColor  = "black"
  res2@xyDashPattern = 2
 
  plot(1) = gsn_csm_xy(wks,time2,vmax_jtwc,res2)
  plot(3) = gsn_csm_xy(wks,time2,slp_jtwc,res2)
  overlay(plot(0),plot(1))
  overlay(plot(2),plot(3))
	
  ; label 
  gres = True
  gres@YPosPercent = 92      ; expressed as %, 0->100, sets position of top border of legend                           ;  when gres@Position is set to its default setting of "Top" (Default = 95.)
  gres@XPosPercent = 15.      ; expressed as %, 0->100, sets position of left border of legend(Default = 5.)
  lineres = True
  lineres@lgLineColors = (/"black","royalblue1","springgreen3","salmon","grey35","grey60"/) ; line colors
  lineres@lgDashIndexes  = (/2,0,0,0,0,16/)
  lineres@lgMonoDashIndex = False
  lineres@lgLineThicknesses = 3                       ; line thicknesses
  lineres@LineLengthPercent = 8.                         ; expressed as %, 0->100, length of line
  textres = True
  textres@lgLabelFont = 25
  textres@lgLabels = (/"~F25~JTWC","~F25~RAD","~F25~CLD","~F25~CTL","~F25~CLEAN","~F25~CLEAN_2"/)  ; legend labels (required)
  textres@lgLabelFontHeights  = 0.012
  textres@lgAutoManage        = False
  legend = simple_legend(wks,plot(0),gres,lineres,textres)
  ; txres               = True   	; text mods desired
  ; txres@txFont        = 25
  ; txres@txFontHeightF = 0.02   
  ; txres@txFontThicknessF = 1.4   ; font smaller. default big
  ; txres@txFontHeightF = 0.012
  ; gsn_text_ndc(wks,"TCG",0.458,0.475,txres)
  gsn_panel(wks,(/plot(0),plot(2)/),(/1,2/),True)

 end

