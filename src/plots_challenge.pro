pro plots_challenge

spawn,'ls *.dat',list

monthave=findgen(5)*0

for i=0,4 do begin
  restore,list[i]
  monthave(i)=mean(binned_people)
endfor

names = ['Dupont Circle', 'Cleveland Park','Airport','Smithsonian','Georgia Ave']

XVAL = FINDGEN(5)/6. + .2

!P.MULTI = [0, 1, 1]

plot,xval,monthave,XRANGE = [0.1,1],/xsty, XTICKV = XVAL,xticks=5,XTICKNAME = NAMES,ps=10,/NODATA,charsize=1.3,background=255, color = 0,tit='EAI, Monthly Average'
FOR I = 0, 4 DO EX_BOX, XVAL[I] - .08, !Y.CRANGE[0], XVAL[I] + 0.08, monthave[I], 128

im=tvrd()
write_jpeg,'figure2.jpeg',im,QUALITY=100

restore,list[0] ; dupont circle example
month_intervals1=month_intervals
binned_people1=binned_people
people_dupont1=people_dupont

restore,list[3]
month_intervals2=month_intervals
binned_people2=binned_people
people_dupont2=people_dupont

!P.MULTI = [0, 1, 2]
plot,month_intervals1,binned_people1,ps=10,/xsty,yran=[0,1.6e6], xtit='JD-2450000',ytit='EAI',charsize=1.3,background=255, color = 0
oplot,month_intervals2,binned_people2,ps=10,co=200

plot,findgen(96)/4,people_dupont1,ps=8,/xsty,ytit='N people',xtit='Hour of day',charsize=1.3,background=255, color = 0
oplot,findgen(96)/4,people_dupont2,ps=8,co=200

im=tvrd()
write_jpeg,'figure1.jpeg',im,QUALITY=100


end


