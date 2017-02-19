 //ping-pong in da action
 int x = 500,
     y = 300,
     speed = 3, 
     xField,
     yField,
     
     //racket coordinates
     r1x1,
     r1y1, 
     r2x1, 
     r2y1;
     
  Boolean Xcheck = false; 
  Boolean Ycheck = false;    
  Boolean isPossibleMove = false;

  String scores;
  
  int scoreLeft;
  int scoreRight;
  int currentLevel;
  int randomNumber;
  
  String[] names = new String[12];
  String firstName;
  String secondName;
     
void setup(){ 
    size(1000,600);
    
    names[0] = "Фредерик\nШопен";
    names[1] = "Пинки Пай";    
    names[2] = "Дед-мороз";
    names[3] = "Терминатор";   
    names[4] = "Сунь Цзы";
    names[5] = "Спанч Боб";    
    names[6] = "Джон Леннон";
    names[7] = "Хатико";   
    names[8] = "Зайчиха из\nЗверополиса";
    names[9] = "Марлен Дитрих";    
    names[10] = "Профессор\nМориарти";
    names[11] = "Иванько\nСтарший";
    
    xField = width/2;
    r1x1 = 900;
    r1y1 = 300;
    r2x1 = 100;
    r2y1 = 300;
    scoreLeft = 0;
    scoreRight = 0;
    currentLevel = 0;
    
    randomNumber = (int)random(6);
    switch(randomNumber){
       case 0: firstName = names[0]; secondName = names[1]; break;
       case 1: firstName = names[2]; secondName = names[3]; break;
       case 2: firstName = names[4]; secondName = names[5]; break;
       case 3: firstName = names[6]; secondName = names[7]; break;
       case 4: firstName = names[8]; secondName = names[9]; break;
       case 5: firstName = names[10]; secondName = names[11]; break;
    }
} 

void draw() { 
    background(255); 
    move(); 
    display(); 
    strokeWeight(5);
    fill(0, 255, 0);
    rect(xField - 50, 30, 100, 60);
    strokeWeight(1);
    fill(0);
    textSize(32);
    text(scoreLeft + ":" + scoreRight, xField - 25, 75);
    textSize(16);
    
    text(firstName, 60, 20);
    text(secondName, 860, 20);
} 

void keyPressed()
{    
  if (!isPossibleMove){  
      randomNumber = (int)random(4);
      switch(randomNumber){
         case 0: Xcheck = false; Ycheck = false; break;
         case 1: Xcheck = false; Ycheck = true;  break;
         case 2: Xcheck = true; Ycheck = false;  break;
         case 3: Xcheck = true; Ycheck = true;  break;
      }
  }
  isPossibleMove = true;
  
    switch(key){
      case 'w': r2y1 -= 10; break;
      case 's': r2y1 += 10; break;
      case 'p': r1y1 -= 10; break;
      case 'l': r1y1 += 10; break;
    }
      r1y1 = constrain( r1y1, 50, 400 );
      r2y1 = constrain( r2y1, 50, 400 );
}

void move() { 
  if (isPossibleMove){
    if(y >= height - 100){ 
        Ycheck = true; 
    }
    else if(y <= 50){ 
        Ycheck = false; 
    } 
    if(!Ycheck){ 
        y += speed; 
    }
    else if(Ycheck) {
        y -= speed;
    } 

    if(x > (r1x1 - 50) && y > r1y1 && y < (r1y1 + 150)){ 
        Xcheck = true; 
    }
    else if(x < r2x1 && y > r2y1 && y < (r2y1 + 150)){ 
        Xcheck = false; 
    }
    else if(x < 50){
        scoreRight++;
        isPossibleMove = false;
        x = 500;
        y = 300;
    }else if(x > 950){
        scoreLeft++;  
        isPossibleMove = false;
        x = 500;
        y = 300;
    }
    if(!Xcheck){ 
        x += speed; 
    } else if(Xcheck) {
        x -= speed; 
    }
    if (scoreRight == 7){
        javax.swing.JOptionPane.showMessageDialog(null, secondName + " победил!");
        scoreLeft = 0;
        scoreRight = 0;
        r1x1 = 900;
        r1y1 = 300;
        r2x1 = 100;
        r2y1 = 300;
    }
    if (scoreLeft == 7){
        javax.swing.JOptionPane.showMessageDialog(null, firstName + " победил!");
        scoreLeft = 0;
        scoreRight = 0;
        r1x1 = 900;
        r1y1 = 300;
        r2x1 = 100;
        r2y1 = 300;
    }
  }
} 


void display() { 
    fill(0); 
    rect(x, y, 50, 50); 

    fill(0);
    rect(r1x1, r1y1, 10, 150);
    
    fill(0);
    rect(r2x1, r2y1, 10, 150);
    
    fill(255, 0, 0);
    rect(0, 550, 1000, height);
    rect(0, 0, 1000, 50);
}