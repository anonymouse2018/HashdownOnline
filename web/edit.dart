///  Hashdown is free software: you can redistribute it and/or modify
///  it under the terms of the GNU General Public License as published by
///  the Free Software Foundation, either version 3 of the License, or
///  (at your option) any later version.

import 'dart:html';
import '../lib/hashdown.dart';
import 'language.dart';
import 'util.dart';
import 'dart:async';

InputElement opPass;

SelectElement selectCode;
SelectElement saltSelect;
LabelElement saltSelectLabel;
Element headerh1;

String pendingInitData;

TextAreaElement inputtext;
TextAreaElement outputtext;
TextAreaElement vinputtext;

DivElement btnBar;

Element encodedTab;

OptionElement shadowCodeOption;
    
void main() {
  Base64UrlCodec.url = window.location
      .toString()
      .replaceFirst(new RegExp(r'\/edit\.html.*'), '/#');

  initLanguage();

  querySelector('.encodeArrow').onClick.listen(onEncode);
  querySelector('.decodeArrow').onClick.listen(onDecode);
  querySelectorAll('.btnBar>button').onClick.listen(onMarkdown);

  querySelector('.encodeV').onClick.listen(onEncodeV);
  querySelector('.decodeV').onClick.listen(onDecodeV);
  querySelector('.markdownVBtn').onClick.listen(onMarkdownV);
  querySelector('.undoV').onClick.listen(onUndoV);

  inputtext = querySelector('#inputtext');
  outputtext = querySelector('#outputtext');
  vinputtext = querySelector('#vinputtext');

  btnBar = querySelector('.btnBar');
  encodedTab = querySelector('#encodedTab');

  opPass = querySelector('#opPass');
  opPass.onInput.listen(onPassInput);

  selectCode = querySelector('.selectCode>select');
  saltSelect = querySelector('#saltSelect');
  saltSelectLabel = querySelector('#saltSelectLabel');
  headerh1 = querySelector('h1');

  shadowCodeOption = document.querySelector('option[value="shadow"');
  
  encodedTab.onClick.listen(onClickLink);

  document.querySelectorAll('.menu > div > label').onClick
      .listen((MouseEvent e) {
    String filename = (e.target as LabelElement).text;
    document.querySelector('.menu').blur();
    loadMd(getLocaleFilename(filename, '.md'));
  });
  checkSize(null);
  window.onResize.listen(checkSize);
  new Timer(new Duration(milliseconds: 500), initAd);

  String hash = window.location.hash;
  OptionElement codecOption;
  if (hash.length > 1) {
    hash = hash.substring(1);
    String loadMd;
    String loadHd;
    if (hash.contains('#')) {
      List hashs = hash.split('#');
      hash = hashs.removeLast();
      for (String cmd in hashs) {
        if (cmd.endsWith('.md')) {
          loadMd = cmd;
        } else if (cmd.endsWith('.h-d')) {
          loadHd = cmd;
        } else {
          Element elm = document.querySelector('option[value="$cmd"');
          if (elm != null) {
            if (elm.classes.contains('codeOpt')) {
              codecOption = elm;
            } else {
              (elm as OptionElement).selected = true;
            }
          }
        }
      }
    }
    if (loadHd != null) {
      () async {
        try {
          String str = await HttpRequest.getString(loadHd);
          decodeData(str);
        } catch (err) {}
      }();
    } /* else if (loadMd != null) {
      
    }*/
    else if (hash.length > 0) {
      decodeData(Base64UrlCodec.url + hash);
    }
  }
  if (codecOption == null) {
    String codec = window.localStorage['codec'];
    if (codec != null) {
      codecOption = document.querySelector('option[value="$codec"');
    }
  }
  if (codecOption != null) {
    window.localStorage['codec'] = codecOption.value;
    if (codecOption.value == Hashdown.SHADOW) {
      inputtext.value = t_('Visible text,{Hidden text}More visible text');
    }
    codecOption.selected = true;
  } else if (Base64UrlCodec.url.indexOf('2e15.com') > 0) {
    (document.querySelector(
        'option[value="base2e15"') as OptionElement).selected = true;
  }

  selectCode.onChange.listen((e) {
    window.location.hash = '#${selectCode.value}#';
    window.localStorage['codec'] = selectCode.value;
    if (selectCode.value == Hashdown.SHADOW) {
      if (inputtext.value == '') {
        inputtext.value = t_('Visible text,{Hidden text}More visible text');
      }
    }
  });
}

/// load markdown file
loadMd(String path) async {
  try {
    String str = await HttpRequest.getString(path);
    inputtext.value = str;
    onMarkdown(null);
  } catch (err) {}
}
void onPassInput(Event e) {
  if (opPass.value == '') {
    saltSelect.disabled = false;
    saltSelectLabel.classes.remove('disabled');
  } else {
    saltSelect.disabled = true;
    saltSelectLabel.classes.add('disabled');
  }
}

bool markdown = false;

void onMarkdown(Event e) {
  HtmlElement elm;
  if (e == null) {
    if (markdown) {
      // force a markdown update
      markdown = false;
      elm = document.querySelector('.btnBar > .blue');
    } else {
      elm = document.querySelector('.btnBar > :last-child');
    }
  } else {
    elm = e.target;
    if (elm.classes.contains('blue')){
      return;
    }
  }
   
  document.querySelector('.btnBar > .blue').classes.remove('blue');
  elm.classes.add('blue');
  
  bool toMarkDown = false;
  if (elm.text == 'A') {
    toMarkDown = false;
    querySelector('.markdownbox').style.display = 'none';
    querySelector('.plainbox').style.display = '';
  } else if (elm.text == '#'){
    toMarkDown = true;
    querySelector('.markdownbox').style.display = '';
    querySelector('.plainbox').style.display = 'none';
  } else { //both
    toMarkDown = true;
    querySelector('.markdownbox').style.display = '';
    querySelector('.plainbox').style.display = '';
  }
  if (toMarkDown == markdown) {
    return;
  }
  markdown = toMarkDown;
  if (markdown) {
     querySelector('.markdownbox > .title').append(btnBar);
     querySelector('.encodeMarkdown').style.display = '';  
     querySelector('#markdown').setInnerHtml(markdownToHtml(inputtext.value, shadowCodeOption.selected),
         validator: markdownValidator);
     if (inputChangeListener == null) {
       inputChangeListener = inputtext.onInput.listen(onMarkdownUpdate);
     }
  } else {
    querySelector('.plainbox > .title').append(btnBar);
    querySelector('.encodeMarkdown').style.display = 'none';
    querySelector('#markdown').innerHtml = '';
    if (inputChangeListener != null) {
      inputChangeListener.cancel();
      inputChangeListener = null;
    }
  }
}
StreamSubscription inputChangeListener;
Timer updateMarkdownTimer;
void onMarkdownUpdate(Event e) {
  if (updateMarkdownTimer != null) {
    updateMarkdownTimer.cancel();
  }
  updateMarkdownTimer =
      new Timer(new Duration(milliseconds: 300), doMarkdownUpdate);
}
void doMarkdownUpdate() {
  updateMarkdownTimer = null;
  if (inputChangeListener == null) return;
  querySelector('#markdown').setInnerHtml(markdownToHtml(inputtext.value, shadowCodeOption.selected),
      validator: markdownValidator);
}

RegExp bracesExp = new RegExp('({.*}|[\u000f-\u001e]{4,})');
void onEncode(Event e) {
  String txt = inputtext.value;
  if (txt != '') {
    HashdownOptions option = getOption(txt, markdown);
    String output = Hashdown.encodeString(txt, option);
    if (option.codec == Hashdown.LINK) {
      setLink(output);
    } else {
      setLink(null);
    }
    outputtext.value = output;

  }
}
String onDecode(Event e) {
  String txt = outputtext.value;
  if (txt != '') {
    HashdownResult result = Hashdown.decode(txt, opPass.value);
    if (result.text == null) {
      if (result.usePassword) {
        inputtext.value = t_('Wrong password');
      } else {
        inputtext.value = t_('Decoding failed');
      }
    } else {
      inputtext.value = result.text;
      changeCodec(result.codec);
      if (result.useMarkdown) {
        onMarkdown(null);
      }
    }
    return result.codec;
  }
  return null;
}

String link;
void setLink(String str) {
  link = str;
  if (link != null) {
    encodedTab.classes.add('linkbtn');
  } else {
    encodedTab.classes.remove('linkbtn');
  }
}

void onClickLink(Event e) {
  if (link != null) {
    window.open(link, '_blank');
  }
}

void onEncodeV(Event e) {
  String txt = vinputtext.value;
  if (txt != '') {
    logHis(txt);
    HashdownOptions option = getOption(txt, markdownV);
    String output = Hashdown.encodeString(txt, option);
    vinputtext.value = output;
    if (markdownV) {
      onMarkdownV(null);
    }
    querySelector('.error').text = '';
  }
}
void onDecodeV(Event e) {
  String txt = vinputtext.value;
  if (txt != '') {
    HashdownResult result = Hashdown.decode(txt, opPass.value);
    if (result.text == null) {
      if (result.usePassword) {
        querySelector('.error').text = t_('Wrong password');
      } else {
        querySelector('.error').text = t_('Decoding failed');
      }
    } else {
      logHis(txt);
      vinputtext.value = result.text;
      changeCodec(result.codec);
      if (result.useMarkdown) {
        markdownV = false; // force a conversion
        onMarkdownV(null);
      }
      querySelector('.error').text = '';
    }
  }
}
List<String> history = [];
void logHis(String str) {
  if (str != null &&
      str != '' &&
      (history.length == 0 || str != history.last)) {
    history.add(str);
    if (history.length == 1) {
      (querySelector('.undoV') as ButtonElement).disabled = false;
    }
  }
}

bool markdownV = false;
void onMarkdownV(Event e) {
  if (markdownV) {
    markdownV = false;
    querySelector('#vmarkdown')
      ..style.display = 'none'
      ..innerHtml = '';
    querySelector('.markdownVBtn').classes.remove('blue');
    querySelector('.encodeV').text = t_('Encode');
    querySelector('.decodeV').style.display = '';
  } else {
    markdownV = true;
    querySelector('#vmarkdown')
      ..style.display = ''
      ..setInnerHtml(markdownToHtml(vinputtext.value, shadowCodeOption.selected),
          validator: markdownValidator);
    querySelector('.markdownVBtn').classes.add('blue');
    querySelector('.encodeV').text = t_('Encode Markdown');
    querySelector('.decodeV').style.display = 'none';
  }
}
void onUndoV(Event e) {
  if (history.length > 0) {
    vinputtext.value = history.removeLast();
    if (history.length == 0) {
      (querySelector('.undoV') as ButtonElement).disabled = true;
    }
    if (markdownV) {
      onMarkdownV(null);
    }
  }
}

HashdownOptions getOption(String str, bool markdown) {
  HashdownOptions opt = new HashdownOptions();
  opt.markdown = markdown;
  opt.password = opPass.value;
  opt.codec = selectCode.value;
  if (opt.password != '') {
    opt.protect = Hashdown.PROTECT_PASSWORD;
  } else {
    opt.protect = saltSelect.value;
  }
  if (str.length < 16 && opt.codec == Hashdown.SHADOW && opt.markdown == false && opt.protect == Hashdown.PROTECT_SALT) {
    // optimize shadow code for short string, don't use default 1 byte salt
    opt.protect = Hashdown.PROTECT_RAW;
  }
  opt.compress = (opt.protect != Hashdown.PROTECT_RAW);
  return opt;
}

void decodeData(String str) {
  if (inited) {
    if (vmode) {
      vinputtext.value = str;
      onDecodeV(null);
    } else {
      outputtext.value = str;
      onDecode(null);
    }
    pendingInitData = null;
  } else {
    pendingInitData = str;
  }

}
void changeCodec(String codec) {
  if (codec != null) {
    Element elm = document.querySelector('option[value="$codec"');
    if (elm != null) {
      (elm as OptionElement).selected = true;
    }
  }
}
bool inited = false;
bool vmode = false;
void checkSize(Event e) {
  headerh1.style.display = window.innerWidth < 445 ? 'none' : '';
  if (window.innerWidth < 480) {
    if (!vmode) {
      document.querySelector('.vbodybox').style.display = '';
      document.querySelector('.bodybox').style.display = 'none';
      vmode = true;
    }
  } else {
    if (vmode || !inited) {
      document.querySelector('.vbodybox').style.display = 'none';
      document.querySelector('.bodybox').style.display = '';
      vmode = false;
    }
  }
  if (pendingInitData != null) {
    decodeData(pendingInitData);
    pendingInitData = null;
  }
}

void initAd() {
  inited = true;
  checkSize(null);
  if (!window.location.protocol.startsWith('http') ||
      document.querySelector('meta[name="hashdownad"][content="enabled"]') ==
          null) {
    return;
  }
  var aboutBox = document.querySelector('.aboutDiv');
  DivElement adDiv = document.createElement('div');
  adDiv.id = 'adDiv';

  if (window.innerWidth < 728) {
    adDiv.style.height = '100px';
    adDiv.style.left = '0';
    adDiv.style.right = '0';
    document.querySelector('.bodybox').style.bottom = '100px';
    document.querySelector('.vbodybox').style.bottom = '100px';

    aboutBox.style.bottom = '105px';
    aboutBox.style.right = '16px';
    adDiv.setInnerHtml(r'''
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- 2e15_mobile -->
<ins class="adsbygoogle"
     style="display:inline-block;width:320px;height:100px;margin:auto;"
     data-ad-client="ca-pub-3283235194066083"
     data-ad-slot="6644918654"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>''', validator: allowAllValidator);
  } else {
    adDiv.style.height = '90px';
    document.querySelector('.bodybox').style.bottom = '90px';
    document.querySelector('.vbodybox').style.bottom = '90px';
    document.querySelector('.downloadDiv').style.display = '';
    aboutBox.style.bottom = '30px';
    aboutBox.style.right = '10px';
    adDiv.setInnerHtml(r'''
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- 2e15_desktop -->
<ins class="adsbygoogle"
     style="display:inline-block;width:728px;height:90px"
     data-ad-client="ca-pub-3283235194066083"
     data-ad-slot="5168185454"></ins>
<script>
(adsbygoogle = window.adsbygoogle || []).push({});
</script>''', validator: allowAllValidator);
  }
  document.querySelector('.sizebox').append(adDiv);
}
