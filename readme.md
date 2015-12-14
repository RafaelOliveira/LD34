Entry for Ludum Dare 34, made with Haxe and Kha

**How to compile**

Install [haxe], [nodejs] and git  
Then on the command line:

Install the haxe lib tweenx:  
```
haxelib install tweenx
```

Clone the project and the submodules:  
```
git clone https://github.com/RafaelOliveira/LD34  
cd LD34  
git submodule update --init --recursive
```

Change the file khafile.js to match the path of tweenx in your system  
If you are using the default installation of haxe on windows, probably is the same path  

Then to to create the html5 project and run in a server:  
```
node Kha/make html5  
node Kha/make --server
```

There is a bug on tweenx that prevents the compilation to windows. Other targets weren't tested.

[nodejs]:https://nodejs.org
[haxe]:http://haxe.org/