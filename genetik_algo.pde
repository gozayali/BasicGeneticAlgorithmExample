int gSize=30;
int jSize=1000;
int jenLimit=100;
int[][] jen=new int[jSize][gSize];
double[] genPower= new double[jSize];
int[] genPuan= new int[jSize];
int[] jenPuan=new int[jenLimit];
int cnt=1;
double caprazProb=0.9;
double mutasyonProb=0.02;
int maxPuan=0;
int maxIndex=0;
String str,str2,sonuc1,sonuc2;

void setup() {
  size(800, 600);
  background(0);
  for (int i=0; i<jSize; i++)
    for (int j=0; j<gSize; j++)
      jen[i][j]=(int)random(1000);
  
  puanla();
  str="";
  str2="";
    for (int j=0; j<gSize; j++) {
      str+=jen[maxIndex][j]+ozellikStr(jen[maxIndex][j]);
      if(j!=gSize-1)
      str+=" - ";
    }
    str2+="Puan: "+  genPuan[maxIndex];
}


void draw() {

  printJen();
 //   if(maxPuan<300)
  if( cnt<jenLimit){
    dogalSecilim();
    caprazla();
    mutasyon();
    cnt++;
  }
  
  //delay(200);
}

void dogalSecilim() {
  
  puanla();
  printJen();

  int[][] tempJen=new int[jSize][gSize];
  double talih;
  for (int i=0; i<jSize; i++) {
    int index=0;
    talih=random(1);
    for (int k=0; k<jSize; k++)
      if ( talih < genPower[k] && index==0 ) {
        index=k;
      }
    for (int j=0; j<gSize; j++) {
      tempJen[i][j]=jen[index][j];
    }
  }

  for (int i=0; i<jSize; i++)
    for (int j=0; j<gSize; j++)
      jen[i][j]=tempJen[i][j];
      
  puanla();

   
}


void caprazla() {

  int[] indexler=new int[jSize];
  for (int i=0; i<jSize; i++)
    indexler[i]=i;

  int index;
  int index2;
  int temp;
  for (int i=0; i<100; i++) {
    index=(int)random(jSize);
    index2=(int)random(jSize);
    temp=indexler[index];
    indexler[index]=indexler[index2];
    indexler[index2]=temp;
  }

  for (int i=0; i<jSize; i++)
    if (i%2==1) {
      if (random(1)<caprazProb) {
        int randIndex=(int)random(gSize);
        for (int j=0; j<gSize; j++)
          if (j>=randIndex) {
            temp=jen[indexler[i]][j];
            jen[indexler[i]][j]=jen[indexler[i-1]][j]; 
            jen[indexler[i-1]][j]=temp;
          }
      }
    }

   puanla();

}

void mutasyon() {

  for (int i=0; i<jSize; i++)
    if (random(1)<mutasyonProb) {
      for (int j=(int)random(gSize); j<gSize; j++) {
        if(jen[i][j]!=0)
        jen[i][j]*=(random(1)+0.5);
        else
        jen[i][j]+=(random(1)+0.5)*100;
      }
    }

  puanla();
  printJen();

}

boolean asallik(int sayi){
  if (sayi <= 1)
    return false;
  else{
    for (int i = 2; i <= sayi/2; i++) {
      int kalan = sayi % i;
      if (kalan == 0)
         return false;
    }
    return true;
  }
}


void printJen() {
  
  background(0);
  fill(250);
  textSize(20);
  text("Yüzden Küçük Asal Sayıları Bulma (Genetik Algoritma)",150,30);
  textSize(10);
  text("Gen Sayısı: "+gSize+", Birey Sayısı: "+jSize+", Son Jenerasyon: "+jenLimit,200,height-30);
  fill(200,200,0);
  text(str2+" / "+10*gSize,30,90);
  text(str,30,100,750,150);

  String str3="";
    for (int j=0; j<gSize; j++) {      
      str3+=jen[maxIndex][j]+ozellikStr(jen[maxIndex][j]);
      if(j!=gSize-1)
      str3+=" - ";
    }
    fill(250,100,100);
    text("İlk Jenerasyonun En İyisi: ",30,70);
    text("Jenerasyon No: "+cnt,30,260);
    fill(0,200,0);
    text("Puan: "+  genPuan[maxIndex]+" / "+10*gSize,30,280);
    text(str3,30,290,750,150);
    
    if(cnt<jenPuan.length)
      jenPuan[cnt]=genPuan[maxIndex];
    fill(255);
    rect(50,450,width-100,height-480);
    fill(250,0,0);
    float xAralik= (float)(width-100)/jenLimit;
    float yAralik= (float)(height-480)/(gSize*10);
    for(int i=1;i<jenPuan.length;i++){
      if(i<=cnt)
        ellipse(50+i*xAralik,(height-30)-(jenPuan[i]*yAralik),3,3);
    }
}


void puanla() {
  int puan;
  int topPuan=0;
  int index=0;
  int max=0;
  for (int i=0; i<jSize; i++) {
    puan=0;
    for (int j=0; j<gSize; j++)
      if (jen[i][j]<100){
        puan+=3;
      if (asallik(jen[i][j]))
        puan+=7;
    }
    genPuan[i]=puan;
    if(genPuan[i]>max) {
      max=genPuan[i];
      index=i;
    }
    genPower[i]=puan;
    topPuan+=puan;
  }

  maxIndex=index;
  maxPuan=max;

  for (int i=0; i<jSize; i++) {
    genPower[i]=genPower[i]/topPuan;
    if (i>0)
      genPower[i]+=genPower[i-1];
  }
}


String ozellikStr(int sayi){
  boolean flag=false;
  String temp="";
  if(asallik(sayi)){
    temp+="A";
    flag=true;
}if(sayi<100){
    temp+="Y";
    flag=true;
}
  if (flag)
  return "("+temp+")";
  else
  return "";
}
