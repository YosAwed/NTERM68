#include	<basic0.h>
#include	<BASIC.h>
#include        <ctype.h>
#include        <doslib.h>
#include        <iocslib.h>
	unsigned char	data[504][128];
	int	ai;
	int	bi;
	int	ci;
	int	bd;
	int	dload_flg;
	int	fc;
	int	loop;
	unsigned char	rs_in;
	unsigned char	rs_out;
	unsigned char	up;
	unsigned char	in_data[2];
	unsigned char	fname[23];
	unsigned char	out_data[2];
	unsigned char	up_filename[23];

/********** program start **********/
void
main()
{
/*   Nangking  Tiny   Terminal
	NTT.C (.bas)
*/
width( 96);
LEDMOD(3,1);
printf("南京　簡易 ＴＥＲＭ Ver0.01\n");
console( 1,30,0);
ai= b_fopen("aux","rw")			;/*Aux (rs232c) file open as var ai*/
dload_flg= 1;
while( 1){
  in();
  out();
}				;/*Main loop*/
exit();
}

/***************************/
int	mode()
{
unsigned char strtmp0[256];
  b_strncpy(sizeof(out_data),out_data,b_inkeyS(strtmp0));
  rs_out= asc(out_data);
  rs_out= toupper(rs_out);
  switch( rs_out){
    case  0x41:;download_off();break;
    case  0x44:;down_load();break;
    case  0x4D:;term_mode();break;
    case  0x51:;term_end();break;
    case  0x55:;up_load();break;
    case  0x58:;x_down();
  }
}

/***************************/
int	in()
{
unsigned char strtmp0[256];
  bd= LOF232C()				;/*iocs call status data from Rs232c*/
  if( bd==0 ){return			;/*If Data is Zero then return to main*/}
  rs_in= b_fgetc(ai);
  b_strncpy(sizeof(in_data),in_data,b_chrS(strtmp0,rs_in));
    b_sprint(in_data);
    if( b_strcmp(in_data,'==',b_chrS(strtmp0,0x8)) )
          {b_sprint(" ");b_sprint(b_chrS(strtmp0,29));b_sprint(b_chrS(strtmp0,29));}
    if( dload_flg==0 ){b_fputc(rs_in,bi);}
}

/***************************/
int	out()
{
unsigned char strtmp0[256];
  b_strncpy(sizeof(out_data),out_data,b_inkey0(strtmp0));
  if( b_strcmp(out_data,'==',"") ){return;}
  if( b_strcmp(out_data,'==',b_chrS(strtmp0,0x1B)) ){mode();return;}
  if( b_strcmp(out_data,'==',b_chrS(strtmp0,0x16)) ){help();return;}
  rs_out= asc(out_data);
  b_fputc(rs_out,ai);
}

/***************************/
int	term_end()
{
int      q;
int	ai;
  printf("ＮＴＴ を終了します。いいかな？ (Y/N) ? ");
  q=INKEY();
  if( (q == 'Y') && (q == 'y') ){
	printf("はい\n" );b_fcloseall();exit(0);}
  printf("いいえ\n");
}

/***************************/
int	up_load()
{
  if( dload_flg==0 ){b_fclose(bi);dload_flg= 1;}
  color(1);
  b_input("file name :? ",sizeof(up_filename),up_filename,-1);
  color(3);
  ci= b_fopen(up_filename,"r");
  do {
    up= b_fgetc(ci);
    if( up!=0xA & up!=0x1A ){fc= b_fputc(up,ai);}
    in();
  } while(!( up==0x1A));
  b_fclose(ci);
}

/***************************/
int	down_load()
{
  if( dload_flg==0 ){beep();printf("既にダウンロード中です。\n");return;}
  color(2);
  b_input("file name ? ",sizeof(fname),fname,-1);
  bi= b_fopen(fname,"c");
  dload_flg= 0;
  color(10);
  printf("log on !\n");b_sprint(STRCRLF);
  color(3);
}

/***************************/
int	download_off()
{
  if( dload_flg==0 ){b_fclose(bi) ;}
           else{beep();printf("既にオフです。\n");return;}
  color(10);printf("log off\n");color(3);
  dload_flg= 1;
}

/***************************/
int	x_down()
{
int	sum;
int	wait;
int	n= 1;
int	mode;
int	c= 0;
int	RS;
int	RSX;
int	i;
unsigned char	rn;
unsigned char	rm;
unsigned char	csum;
unsigned char	SOH= 0x1;
unsigned char	NAK= 0x15;
unsigned char	EOT= 0x4;
unsigned char	ACK= 0x6;
unsigned char	send;
unsigned char	xname[23];
  fc= b_fclose(ai);
  RS= SET232C(-1);
  RSX= (RS & 0xFDFF);
  SET232C(RSX);
  ai= b_fopen("aux","rw");
  if( dload_flg==0 ){b_fclose(bi);dload_flg= 1;}
  while( LOF232C()>0){
    rs_in= b_fgetc(ai);
  }
  color(7);b_input("X-MODEM DOWN LOAD  File Name ? ",sizeof(xname),xname,-1);color(3);
  send= NAK;
  fc= b_fputc(send,ai);
  while( 1){
    mode= 0;wait= 0;
    while( LOF232C()==0){
      wait= wait+1;
      if( wait>=500000 & LOF232C()==0 ){wait= 0;fc= b_fputc(send,ai);}
    }
    sum= 0;
    rs_in= b_fgetc(ai);
    if( rs_in==EOT ){break;}
    if( rs_in!=SOH ){mode= 2;}
    rn= b_fgetc(ai);rm= b_fgetc(ai);
    if( mode==0 & (rn+rm)!=255 ){mode= 2;}
    if( mode==0 & rn==n+1 ){mode= 1;}
    for(loop=0 ;loop<= 127;loop++){
      data[c][loop]= b_fgetc(ai);
      sum= sum+data[c][loop];
      if( sum>255 ){sum= sum-256;}
    }
    csum= b_fgetc(ai);
    if( (mode==0) & (sum!=csum) ){mode= 2;}
    if( mode==2 ){send= NAK ;}else{send= ACK;}
    if( n==255 ){n= 0 ;}else{n= n+1;}
    if( mode!=0 ){n= n-1 ;}else{c= c+1;}
    fc= b_fputc(send,ai);
    b_iprint(c);
  }
  fc= b_fputc(ACK,ai);
  printf("data writing..\n");
  SET232C(RS);
  ci= b_fopen(xname,"c");
  for(i=0 ;i<= c-1;i++){
    for(loop=0 ;loop<= 127;loop++){
      fc= b_fputc(data[i][loop],ci);
    }
  }
  b_fclose(ci);
}

/***************************/
int	help()
{
  printf("\n");
  printf("+------------------------------------+\n");
  printf("  コマンド説明\n");
  printf("    ＥＳＣキーを押した後\n");
  printf("        Ｕ…アップロード\n");
  printf("        Ｄ…ダウンロード開始\n");
  printf("        Ａ…ダウンロード終了\n");
  printf("        Ｘ…X-MODEM fileダウンロード\n");
  printf("        Ｑ…プログラム終了\n");
  printf("        Ｍ…ボーレート設定\n");
  printf("+------------------------------------+\n");
}

/***************************/
int	term_mode()
{
int	mode;
  printf("ボーレートを変更します\n\n");
  printf("    1...300bps.\n");
  printf("    2..1200bps.\n");
  printf("\n");
  b_input("  どれにしますか? ",0x204,&mode,-1);
  switch( mode){
    case  1:;SET232C(0x4E02);break;
    case  2:;SET232C(0x4E04);
  }
}

/***************************/
