# Custom CSS

Hashdown允许任何自定义的css

## 背景

黑色背景和白色文字

<style>
body{
 background:url("hashdown.png");
}
.markdown{
 background: -webkit-linear-gradient(-45deg,  #4c4c4c 0%,#666666 25%,#474747 39%,#111111 60%,#131313 100%);
 background: linear-gradient(135deg,  #4c4c4c 0%,#666666 25%,#474747 39%,#111111 60%,#131313 100%);
 color:white;
-webkit-border-radius: 20px 0;
border-radius: 20px 0;
}
.markdown h1,.markdown h2,.markdown h3 {
color:white;
}
</style>

## 网页字体

<link href='http://fonts.googleapis.com/css?family=Indie+Flower' rel='stylesheet' type='text/css'>

<span style="font-family:'Indie Flower',cursive;font-size:20px">Indie Flower font</span>

## 动画

<style>
#animated
{
position:relative;
background:#AAAAAA;
animation:animated_div 5s infinite;
-webkit-animation:animated_div 5s infinite;
border-radius:5px;
}

@keyframes animated_div
{
0%    {transform: rotate(0deg);left:0px;}
50%   {transform: rotate(0deg);left:500px;}
70%   {transform: rotate(0deg);left:500px;background:#ffffff;}
100%  {transform: rotate(-360deg);left:0px;}
}

@-webkit-keyframes animated_div
{
0%    {-webkit-transform: rotate(0deg);left:0px;}
50%   {-webkit-transform: rotate(0deg);left:500px;}
70%   {-webkit-transform: rotate(0deg);left:500px;background:#ffffff;}
100%  {-webkit-transform: rotate(-360deg);left:0px;}
}

</style>

<img src="hashdown.png" id="animated">

## 文字阴影

<style>
#texteffect { 
margin:20px;
font-size: 20px; 
letter-spacing: 1px;
text-shadow: 3px 3px 3px #F33; 
}
</style>

<span id="texteffect">文字阴影</span>


