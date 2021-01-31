This is a mirror of http://www.vim.org/scripts/script.php?script_id=2596, based on xqin's modifications here: https://github.com/xqin/gvimfullscreen

Allows you to run gvim in full screen on Windows on a single monitor.

This is a copy of Yasuhiro Matsumoto's VimTweak's EnableMaximize functionality modified to deal with window borders and allowing the window to overlap the task bar.


* 修复在多个显示器下将GVim切入全屏时只能在主显示器全屏的问题.
* 修复在将GVim窗口切换到全屏时,窗口右侧和底部出现的白色边框(白边)问题.
* 准确记录GVim窗口的大小,坐标,状态等信息,由全屏切回正常窗口时准确还原切换前的状态.
* 增加设置GVim窗口透明度和置顶的功能.


#使用方法
```
:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)
```

#vimrc 配置实例:
```
if has('gui_running') && has('libcall')
	let g:MyVimLib = $VIMRUNTIME.'/gvimfullscreen.dll'
	function ToggleFullScreen()
		call libcallnr(g:MyVimLib, "ToggleFullScreen", 0)
	endfunction
    
	"Alt+Enter
	map <A-Enter> <Esc>:call ToggleFullScreen()<CR>

	let g:VimAlpha = 240
	function! SetAlpha(alpha)
		let g:VimAlpha = g:VimAlpha + a:alpha
		if g:VimAlpha < 180
			let g:VimAlpha = 180
		endif
		if g:VimAlpha > 255
			let g:VimAlpha = 255
		endif
		call libcall(g:MyVimLib, 'SetAlpha', g:VimAlpha)
	endfunction
    
	"Shift+Y
	nmap <s-y> <Esc>:call SetAlpha(3)<CR>
	"Shift+T
	nmap <s-t> <Esc>:call SetAlpha(-3)<CR>

	let g:VimTopMost = 0
	function! SwitchVimTopMostMode()
		if g:VimTopMost == 0
			let g:VimTopMost = 1
		else
			let g:VimTopMost = 0
		endif
		call libcall(g:MyVimLib, 'EnableTopMost', g:VimTopMost)
	endfunction
    
	"Shift+R
	nmap <s-r> <Esc>:call SwitchVimTopMostMode()<CR>
endif
```

#dll文件说明

`gvimfullscreen.dll`	for x86(32位)
`gvimfullscreen.dll.x64`	for x64(64位,使用时请将.x64的扩展名去掉)



#全屏后GVim窗口的一些小问题.
* 可能会存在全屏后窗口仍有一部分边框的问题, 可以通过修改`src/gui_w32.c`来解决.

```
diff -r 87ef9ff527dd src/gui_w32.c
--- a/src/gui_w32.c     Tue Nov 05 17:40:53 2013 +0100
+++ b/src/gui_w32.c     Wed Nov 06 10:54:51 2013 +0800
@@ -1516,7 +1516,8 @@
            return FAIL;
     }
     s_textArea = CreateWindowEx(
-       WS_EX_CLIENTEDGE,
+        /*WS_EX_CLIENTEDGE,*/
+        0,
        szTextAreaClass, "Vim text area",
        WS_CHILD | WS_VISIBLE, 0, 0,
        100,                            /* Any value will do for now */
@@ -1565,7 +1566,8 @@
     /*
      * Start out by adding the configured border width into the border offset
      */
-    gui.border_offset = gui.border_width + 2;  /*CLIENT EDGE*/
+    /*gui.border_offset = gui.border_width + 2;        [>CLIENT EDGE<]*/
+    gui.border_offset = gui.border_width;

     /*
      * Set up for Intellimouse processing
```
