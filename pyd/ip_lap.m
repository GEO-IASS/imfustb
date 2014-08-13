function im=ipdt(pyramid)%, w, sigma)

%w=fspecial('gaussian', [1, w], sigma)

[m, n]=size(pyramid{1});
im=zeros(m, n);

w  = [1 4 6 4 1] / 16;

[wm, wn]=size(w);
extend=floor(length(w)/2);
extendm=ceil(wm/2);
extendn=ceil(wn/2);


lp=pyramid{length(pyramid)};
for i=length(pyramid)-1:-1:1
	hp=pyramid{i};

	[lpm, lpn]=size(lp);
	newlp=zeros(2*lpm, 2*lpn);
	newlp(1:2:2*lpm, 1:2:2*lpn)=lp;
	%newlp=imresize(lp, [2*lpm, 2*lpn]);
	%figure(30); imshow(uint8(newlp)); pause;
	newlp=conv2(ut_es2(newlp, extend), 2*w, 'valid');
	%figure(30); imshow(uint8(newlp)); pause;
	newlp=conv2(newlp, 2*w', 'valid');
	%figure(30); imshow(uint8(newlp)); pause;
	newlp=newlp+hp;
	%figure(30); imshow(uint8(newlp)); pause;
	
	lp=newlp;
end

im=lp;
