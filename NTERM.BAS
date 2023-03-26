/*   Nangking  Tiny   Terminal   */
/*      NTT.C (.bas)             */
/*                               */
dim char data(503,127)
int ai,bi,ci,bd,dload_flg,fc,loop
char rs_in,rs_out,up
str in_data[1],fname[22],out_data[1],up_filename[22]
width 96
LEDMOD(3,1)
print"南京　簡易 ＴＥＲＭ Ver0.01"
console 1,30,0
ai=fopen("aux","rw")			:/*Aux (rs232c) file open as var ai
dload_flg=1
while 1
  in()
  out()
endwhile				:/*Main loop
func mode()
  out_data=inkey$
  rs_out=asc(out_data)
  rs_out=toupper(rs_out)
  switch rs_out
    case &H41:download_off():break
    case &H44:down_load():break
    case &H4D:term_mode():break
    case &H51:term_end():break
    case &H55:up_load():break
    case &H58:x_down()
  endswitch
endfunc
func in()
  bd=LOF232C()				:/*iocs call status data from Rs232c
  if bd=0 then return()			:/*If Data is Zero then return to main
  rs_in=fgetc(ai)
  in_data=chr$(rs_in)
    print in_data;
    if in_data=chr$(&H8) then print" ";chr$(29);chr$(29);
    if dload_flg=0 then fputc(rs_in,bi)
endfunc
func out()
  out_data=inkey$(0)
  if out_data="" then return()
  if out_data=chr$(&H1B) then mode():return()
  if out_data=chr$(&H16) then help():return()
  rs_out=asc(out_data)
  fputc(rs_out,ai)
endfunc
func term_end()
  str q
  int ai
  print"ＮＴＴ を終了します。いいかな？ (Y/N) ? ";
  q=inkey$
  ai=asc(q)
  ai=toupper(q)
  q=chr$(ai)
  if q="Y" then print "はい" :fcloseall():end
  print"いいえ"
endfunc
func up_load()
  if dload_flg=0 then fclose(bi):dload_flg=1
  color 1
  input"file name :";up_filename
  color 3
  ci=fopen(up_filename,"r")
  repeat
    up=fgetc(ci)
    if up<>&HA and up<>&H1A then fc=fputc(up,ai)
    in()
  until up=&H1A
  fclose(ci)
endfunc
func down_load()
  if dload_flg=0 then beep:print "既にダウンロード中です。":return()
  color 2
  input"file name ";fname
  bi=fopen(fname,"c")
  dload_flg=0
  color 10
  print"log on !"
  color 3
endfunc
func download_off()
  if dload_flg=0 then fclose(bi) else beep:print"既にオフです。":return()
  color 10:print"log off":color 3
  dload_flg=1
endfunc
func x_down()
  int sum,wait,n=1,mode,c=0,RS,RSX,i
  char rn,rm,csum,SOH=&H1,NAK=&H15,EOT=&H4,ACK=&H6,send
  str xname[22]
  fc=fclose(ai)
  RS=SET232C(-1)
  RSX=(RS and &HFDFF)
  SET232C(RSX)
  ai=fopen("aux","rw")
  if dload_flg=0 then fclose(bi):dload_flg=1
  while LOF232C()>0
    rs_in=fgetc(ai)
  endwhile
  color 7:input"X-MODEM DOWN LOAD  File Name ";xname:color 3
  send=NAK
  fc=fputc(send,ai)
  while 1
    mode=0:wait=0
    while LOF232C()=0
      wait=wait+1
      if wait>=500000 and LOF232C()=0 then wait=0:fc=fputc(send,ai)
    endwhile
    sum=0
    rs_in=fgetc(ai)
    if rs_in=EOT then break
    if rs_in<>SOH then mode=2
    rn=fgetc(ai):rm=fgetc(ai)
    if mode=0 and (rn+rm)<>255 then mode=2
    if mode=0 and rn=n+1 then mode=1
    for loop=0 to 127
      data(c,loop)=fgetc(ai)
      sum=sum+data(c,loop)
      if sum>255 then sum=sum-256
    next
    csum=fgetc(ai)
    if (mode=0) and (sum<>csum) then mode=2
    if mode=2 then send=NAK else send=ACK
    if n=255 then n=0 else n=n+1
    if mode<>0 then n=n-1 else c=c+1
    fc=fputc(send,ai)
    print c;
  endwhile
  fc=fputc(ACK,ai)
  print"data writing.."
  SET232C(RS)
  ci=fopen(xname,"c")
  for i=0 to c-1
    for loop=0 to 127
      fc=fputc(data(i,loop),ci)
    next
  next
  fclose(ci)
endfunc
func help()
  print
  print"+------------------------------------+"
  print"  コマンド説明"
  print"    ＥＳＣキーを押した後"
  print"        Ｕ…アップロード"
  print"        Ｄ…ダウンロード開始"
  print"        Ａ…ダウンロード終了"
  print"        Ｘ…X-MODEM fileダウンロード"
  print"        Ｑ…プログラム終了
  print"        Ｍ…ボーレート設定"
  print"+------------------------------------+"
endfunc
func term_mode()
  int mode
  print"ボーレートを変更します"
  print
  print"    1...300bps."
  print"    2..1200bps."
  print
  input"  どれにしますか";mode
  switch mode
    case 1:SET232C(&H4E02):break
    case 2:SET232C(&H4E04)
  endswitch
endfunc
