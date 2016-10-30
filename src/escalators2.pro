pro escalators2,statcode

;.r /Users/parriaga/idle/astron/pro/readcol.pro                                                                                                         
readcol,'unit_statuses.csv',unit_id,time,end_time,metro_open_time,update_type,symptom_description,symptom_category,format='A,A,A,A,A,A,A',delimiter=','

count=n_elements(time)
juliantime=dindgen(count)*0
end_julian=dindgen(count)*0


for i=1,count-1 do begin
 datecalc,time(i),juliandate
 juliantime(i)=juliandate
 if end_time(i) ne '"NA"' then begin
   datecalc,end_time(i),julianend
   end_julian(i)=julianend
 endif
endfor

;when were any of the  escalators broken at station "statcode"
broken=where(end_julian ne 0.0 and update_type eq '"Break"' and strmid(unit_id,1,3) eq statcode)

;calculate julian times for beginning and end
juliantime_dupont=juliantime(broken)
endjulian_dupont=end_julian(broken)
unit_id_dupont=unit_id(broken)

;where are starting and ending?
first_day=juliantime_dupont(0)
caldat,first_day,month,day,year,hour,minutes,seconds
first_day_start=julday(month,day,year)

end_day=endjulian_dupont(n_elements(endjulian_dupont)-1)
caldat,end_day,month,day,year,hour,minutes,seconds
final_day_end=julday(month,day+1,year)
offset=2450000.

;generate an array of times with 15 minutes intervals starting with the first day we have data on
times_with_steps=TIMEGEN(START=first_day_start-offset, FINAL=final_day_end-offset, UNITS='Hours',step_size=0.25)
is_it_broken=times_with_steps*0

;Now let's see when things were broken
for i=0,n_elements(times_with_steps)-2 do begin
  t1=times_with_steps(i)
  t2=times_with_steps(i+1) 

  for j=0,n_elements(juliantime_dupont)-1 do begin
    t1b=juliantime_dupont(j)-offset
    t2b=endjulian_dupont(j)-offset
    if t1b le t1 and t2b ge t2 then is_it_broken(i)=1
  endfor
endfor

;Now, what number of people will encounter the broken stair
peoplein=read_csv('station_activity_15_minutes/entries.csv')
peopleout=read_csv('station_activity_15_minutes/exits.csv')

if statcode eq 'C10' then people_dupont=peoplein.field62+peopleout.field62 ; C10
if statcode eq 'A03' then people_dupont=peoplein.field24+peopleout.field24 ; A03
if statcode eq 'D02' then people_dupont=peoplein.field69+peopleout.field69 ; D02
if statcode eq 'A05' then people_dupont=peoplein.field16+peopleout.field16 ; A05
if statcode eq 'E05' then people_dupont=peoplein.field38+peopleout.field38 ; E05

missing=indgen(15)*0 ;when the station is closed between 1 am and 4.45 am
 
people_dupont=[missing,people_dupont]

annoyed=is_it_broken*0

for i=0,n_elements(is_it_broken)-97 do begin
 for j=0,95 do annoyed(j+i)=is_it_broken(j+i)*people_dupont(j)
 i=i+96
endfor

month_intervals=TIMEGEN(START=first_day_start-offset, FINAL=final_day_end-offset, UNITS='Months',step_size=1)
binned_people=month_intervals

for i=0,n_elements(month_intervals)-2 do begin
  q=where(times_with_steps ge month_intervals(i) and times_with_steps lt month_intervals(i+1))
  binned_people(i)=total(annoyed(q))
endfor

!P.MULTI = [0, 1, 2]
plot,month_intervals,binned_people,ps=10,/xsty, xtit='JD-2450000',ytit='N people'
plot,findgen(96)/4,people_dupont,ps=8,/xsty,ytit='N people',xtit='Hour of day'

save,file=statcode+'.dat',month_intervals,binned_people,people_dupont
end
