;-----------------
;date:2019/12/21  
;author: mar      
;-----------------

;reading best track of TC from wrf simulation data in a moving nest
;open wrf data
  filename    = "../WRFoutput"
  outputName  = "ReProcess/CLD.txt"
  interval    = 1
  
  f           = addfile(filename,"r")
  times       = wrf_user_getvar(f,"times",-1)
  nps         = (dimsizes(times)-1)/interval+1 
  centLat     = new(nps,"float")
  centLat2    = new(nps,"float")
  centLon     = new(nps,"float")
  centLon2    = new(nps,"float")
  minP        = new(nps,"float")
  rmw         = new(nps,"float")
  maxV        = new(nps,"float")
  time        = new(nps,"string") 
  k           = 0
  dx          = 3

;calculate minimum sea surface presurre and maximum wind speed at 10m
do i=0, dimsizes(times)-1,interval
	 lat         = wrf_user_getvar(f,"lat",i)
	 lon         = wrf_user_getvar(f,"lon",i)
	 p           = wrf_user_getvar(f,"slp",i)
     u10         = f->U10(i,:,:)
	 v10         = f->V10(i,:,:)
     time(k)     = times(i)
;calculat max wind and print their location
	 usped   = wind_speed(u10,v10)
;calculate minimum sea surface presurre and coordinates 
	 p1d     = ndtooned(p)
     dims        = dimsizes(p)
     minP(k)     = min(p1d)
     minij       = ind_resolve(minind(p1d),dims)
	 minu        = usped(minij(0,0),minij(0,1))
	 minl1       = minij(0,0)
	 minl2       = minij(0,1)
	 centLat2(k)        = lat(minl1,minl2)
   	 centLon2(k)        = lon(minl1,minl2)
	 do l1=0,dimsizes(lat(0,:))-1
		do l2=0,dimsizes(lat(:,0))-1
			r   = dx*sqrt((l1-minij(0,0))^2+(l2-minij(0,1))^2)
			if (r.le.100.and.p(l1,l2).le.1010) then
				if (minu.ge.usped(l1,l2)) then
					minu   = usped(l1,l2)
					minl1  = l1
					minl2  = l2
				;	print((/minu/))
				end if 
			end if
		end do
	end do
    pi          = minl1
    pj          = minl2
    centLat(k)  = lat(pi,pj)
    centLon(k)  = lon(pi,pj)
	maxu        = usped(pi,pj)
	do l1=0,dimsizes(lat(:,0))-1
		do l2=0,dimsizes(lat(0,:))-1
			r          = dx*sqrt((l1-pi)^2+(l2-pj)^2)
			if (r.le.400.and.usped(l1,l2).gt.0) then
				if (maxu.le.usped(l1,l2)) then
					maxu   = usped(l1,l2)
					ui     = l1
					uj     = l2	
					;print((/maxu/))
				end if 
			end if
		end do
	end do
	maxV(k)     = maxu/0.514444 
	rmw(k)      = dx*sqrt((ui-pi)^2+(uj-pj)^2)
    k           = k + 1
    print((/k/))     
end do
  
  write_table(outputName,"w",[/time,centLat,centLon,maxV,minP,centLat2,centLon2/],\
  "%s,  %4.2f,  %5.2f,  %4.1f,  %6.2f,  %5.2f,  %4.2f,  %5.2f")




