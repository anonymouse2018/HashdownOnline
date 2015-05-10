# Hashdown

Hashdown在线工具可以转换文本，使之更易于被分享

http://www.hashdown.net/edit.html

支持三种编码模式

## Hashdown链接

Hashdown链接把文本以哈希的方式转换到Url中

例子:  
http://www.hashdown.net/#SGFzaERvd24gTGluayBpcyBBd2Vzb21l

#### 理由?

你当然可以把文本写在博客之类在线服务，然后分享链接。但Hashdown链接的工作原理和那截然不同

* 编解码完全在客户端完成，服务器永远都不知道用户编码了哪些内容. 链接的哈希(Url中#之后的部分)不会被发送到网络中。
* 即使服务器下线或被屏蔽，你的内容也不会丢失，只要能找到任何Hashdown的镜像网站，或者离线版的Hashdown工具，内容仍可以被还原。
* Hashdown支持密码加密。

#### 短域名服务
短域名服务非常适合与Hashdown链接配合使用，比如: http://goo.gl/Oz9MJu

但如果短域名服务本身下线或被屏蔽，内容也会随之一起丢失

## Hashdown Base2e15

[Base2e15](https://github.com/rinick/base2e15)将文本转换成Unicode字符，每个字符存储15比特数据

在加上Hashdown本身支持压缩，这能在有限的字符里存储更多的数据

样本数据 ( **322字符** )
```
In URIs a hashmark # introduces the optional fragment near the end of the URL. The generic RFC 3986 syntax for URIs also allows an optional query part introduced by a question mark ?. In URIs with a query and a fragment, the fragment follows the query. Query parts depend on the URI scheme and are evaluated by the server.
```
转换到Base2e15 ( **114字符** )
```
蜵웦孴쮨廳擽땧䅧橔䑚쌳唜峇땢榃堻嗐歱揘芊쁷䌷䬕䆪㽍蜞芻䂜뗊俅뀾塙륡곻摡壱䉌捃玺뫂쑽릆샱糓䀡윷㚂䰒㾎렷䝿닸孔쯝禑揩㦊莛蔍嬚쥎䕾涩屇灞䣽浚껲净꼏掸煜㳌낣췹哈潶㘁唺캮㳳萯德왔뒉䜠澎㴺데瀊킊炛㴕渄味䈥폺뙉臋艺몪爱닄焍薍䩨感휧夻프쨭㿊줘㐀
```

## Hashdown蝌蚪码
蝌蚪码通过Unicode中特殊的组合字符把许多字符显示在一个字符的空间

样本数据
```
In URIs a hashmark # introduces the optional fragment near the end of the URL. The generic RFC 3986 syntax for URIs also allows an optional query part introduced by a question mark ?. In URIs with a query and a fragment, the fragment follows the query. Query parts depend on the URI scheme and are evaluated by the server.
```
蝌蚪码:

&nbsp; /̶⃙̸̴⃘̸⃙̷̶⃘̵⃙̵̷̷⃙⃚⃘̶⃙̷̴̷⃙⃘⃚̴̷⃘⃚⃚⃘̸⃘⃘̵̷̵⃚⃘⃙̵⃚⃙̵⃙⃚̵⃚̸⃙⃘̴⃘̴̶̴̷⃙̴⃘̵̷̸⃚̶̴̴̴̴̸̵̵̷⃙⃘̶̸̵̶⃙̶⃙⃙̶̷̴̵⃘̷̴̸̷̴̸̷̸̴̵⃙̵̵̶⃚̶⃙⃚⃚̶⃚⃙̸̷̶̵̵̸̵̶̷⃚̶̷⃚⃚⃘̵̶⃚̸⃙̶̴̴̵⃘̷⃘̶̷⃙̶̵⃘̷̶⃙⃙̸̷⃙⃚̸̵̶̵̴̶̸⃘⃚̴̶̵̴̸̷⃚̸⃘⃚̴̴̴⃘̷̴̷⃚̵⃘̴⃘̴⃘̶̴̷̸⃙⃙̴⃙⃚⃙⃚̵̷̶̷̵̴̸⃙ًًًًًًًًًًًًًًًًًًًًٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٌٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍَََََََََََََََََََََََََََََََََُُُُُُُُُُُُُُُُُُُُُُٰٰٰٰٰٰٰٰٰٰٰٰٰٰٰٰٰٰٰٰٰٰٰٰٰٰٰٰٰٰٰٰۤۤۤۤۤۤۤۤۤۤۤۤۤۤۤۤۤۤۤۤۤۤۤۤۤۤۤ͘͘͘͘͘͘͘͘͘͘͘͘͘͘͘͘͘͘͘͘͘͘͘͘͘͘͘͘͘,  &nbsp; &nbsp; ( 这里其实有**426**个字符!! )

# API

在javascript或dart中编解码Hashdown

## javascript

```html
    <script src="http://www.hashdown.net/api.js"></script>
    <script>
      // simple encoding/decoding
      var encoded1 = $hashdown.encode('Hashdown is awesome');
      var decoded1 = $hashdown.decode(encoded1);

      // encoding with options
      var encoded2 = $hashdown.encode('Hashdown is awesome',{
      	"codec" : $hashdown.BASE2E15,
      	"markdown" : true,
      	"protect" :  $hashdown.PROTECT_PASSWORD,
      	"password" : "mypassword"
      });
      var decoded2 = $hashdown.decode(encoded2, 'mypassword').text;
    </script>
```

## dart

```dart
	import 'package:hashdown/hashdown.dart';
	
	void main() {
	  // encode string to hashdown link
	  String hashdownLink =
	      Hashdown.encodeString('Hashdown is awesome', new HashdownOptions());
	  
	  // encode string to base2e15
	  String base2e15 = Hashdown.encodeString(
	      'Hashdown is awesome', new HashdownOptions()..codec = Hashdown.BASE2E15);
	}
```
