cd doc
chxdoc.exe -f flash -f haxe -f neko -f php -f test --installTemplate=true --showPrivateClasses=false --showPrivateTypedefs=false --showPrivateEnums=false --showPrivateMethods=false --showPrivateVars=false --generateTodoFile=true --showTodoTags=true --ignoreRoot=true --title=ufront doc.neko.xml,neko
;doc.php.xml,php
cd ..
PAUSE