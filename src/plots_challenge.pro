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

plot,xval,monthave,XRANGE = [0.1,1],/xsty, XTICKV = XVAL,xticks=5,XTICKNAME = NAMES,ps=10,/NODATA,charsize=1.3,background=255, color = 0,tit='Number of affected people, Monthly Average'
FOR I = 0, 4 DO EX_BOX, XVAL[I] - .08, !Y.CRANGE[0], XVAL[I] + 0.08, monthave[I], 128

im=tvrd()
write_jpeg,'figure2.jpeg',im,QUALITY=100

restore,list[1] ; dupont circle example

!P.MULTI = [0, 1, 2]
plot,month_intervals,binned_people,ps=10,/xsty, xtit='JD-2450000',ytit='N people',charsize=1.3,background=255, color = 0, tit='Number of people at Dupont Circle'
plot,findgen(96)/4,people_dupont,ps=8,/xsty,ytit='N people',xtit='Hour of day',charsize=1.3,background=255, color = 0

im=tvrd()
write_jpeg,'figure1.jpeg',im,QUALITY=100


end


