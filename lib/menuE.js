const topLevel = document.querySelector('div.topLevel');
const section = document.createElement('section');
section.setAttribute('class', 'menu');
topLevel.appendChild(section);
//macOS
section.appendChild(setTitle(['lm10', 'tm20', 'bm0'], 'macOS')); 
section.appendChild(setMenu(['lm30', 'tm0', 'bm0'], '/lib/indexE1.html', '_self', 'Applications & Parts')); 
section.appendChild(setMenu(['lm30', 'tm5', 'bm0'], '/lib/indexE2.html', '_self', 'General Objects')); 
//section.appendChild(setMenu(['lm30', 'tm5', 'bm0'], '/lib/index3.html', '_self', 'ウィンドウ')); 
//section.appendChild(setMenu(['lm30', 'tm5', 'bm0'], '/lib/index4.html', '_self', 'ビュー')); 
//section.appendChild(setMenu(['lm30', 'tm5', 'bm0'], '/lib/index5.html', '_self', 'コントロール')); 
//section.appendChild(setMenu(['lm30', 'tm5', 'bm0'], '/lib/index6.html', '_self', 'ファイル・ネットワーク')); 
//section.appendChild(setMenu(['lm30', 'tm5', 'bm0'], '/lib/index7.html', '_self', 'システム構築')); 
//section.appendChild(setMenu(['lm30', 'tm5', 'bm0'], '/lib/index9.html', '_self', 'コーディング・サンプル')); 
//section.appendChild(setMenu(['lm30', 'tm5', 'bm20'], '/lib/search/search_os.html', '_blank', '&#x21B3;文字列検索')); 
//iOS
section.appendChild(setTitle(['lm10', 'tm10', 'bm0'], 'iOS')); 
section.appendChild(setMenu(['lm30', 'tm0', 'bm0'], '/lib/indexE8.html', '_self', 'Applications')); 
section.appendChild(setMenu(['lm30', 'tm5', 'bm0'], '/lib/indexE13.html', '_self', 'iOS Techniques')); 
//C#
section.appendChild(setTitle(['lm10', 'tm10', 'bm0'], 'C#')); 
section.appendChild(setMenu(['lm30', 'tm0', 'bm20'], '/lib/indexE14.html', '_self', 'Applications'));

//section.appendChild(setMenu(['lm30', 'tm5', 'bm20'], '/lib/index13.html', '_self', '技法')); 
//JavaScript/PHP
//section.appendChild(setTitle(['lm10', 'tm10', 'bm0'], 'JavaScript&thinsp;/&thinsp;PHP')); 
//section.appendChild(setMenu(['lm30', 'tm0', 'bm0'], '/lib/index10.html', '_self', '技法')); 
//section.appendChild(setMenu(['lm30', 'tm5', 'bm0'], '/lib/index11.html', '_self', 'コーディング・サンプル')); 
//section.appendChild(setMenu(['lm30', 'tm5', 'bm20'], '/lib/search/search_html.html', '_blank', '&#x21B3;文字列検索')); 
//COBOL
//section.appendChild(setTitle(['lm10', 'tm10', 'bm0'], 'COBOL')); 
//section.appendChild(setMenu(['lm30', 'tm0', 'bm20'], '/lib/index12.html', '_self', '技法')); 

section.appendChild(setMenu(['lm10', 'tm40', 'bm0'], '/lib/index1.html', '_self', '日本語')); 


function setTitle(itemList, text){
    const tytle = document.createElement('h3');
    tytle.classList.add(...itemList);
    tytle.innerHTML = text;
    return tytle;
}
function setMenu(itemList, url, target, text){
    const menu = document.createElement('h4');
    menu.classList.add(...itemList); //残余引数
    const href = document.createElement('a');
    href.setAttribute('href', url);
    href.setAttribute('target', target);
    href.innerHTML = text; 
    menu.appendChild(href);
    return menu;
}

