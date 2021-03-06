function [err, errmap]=dm_qtdfuscap(a, b, md)

%ent_a=ut_entropy(a)
%ent_b=ut_entropy(b)

%md=2^(log2(md)-1)
%md=md/2;

%ent_a=mean2(bk_entropy(a, zeros(md, md)))
%ent_b=mean2(bk_entropy(b, zeros(md, md)))

%[q_a, b_a, d_a]=ut_qtd(a, ent_a, 10);
%[q_b, b_b, d_b]=ut_qtd(b, ent_b, 20);


%entropythreshold=min(ent_a, ent_b);%*2/3;
%entropythreshold=(ent_a+ ent_b)/2
%entropythreshold=ent_a

entropy(a)
entropythreshold=entropy(a)/2;

%[q_a, b_a, d_a]=ut_qtd(a, entropythreshold, 30);

%[qa, ba, da]=ut_qtd(a, entropythreshold, 0);
%[qb, bb, db]=ut_qtd(b, entropythreshold, 0);

mindim=2;%16;%2;
maxdim=16;%min(size(a, 1))/2;

im=a;

% if ent_a<ent_b
% %if ent_a>ent_b
%     im=a;
% else
%     im=b;
% end

q=qtdecomp(im, @ut_qtentropy, entropythreshold, [mindim, maxdim]);

numblks=length(find(q));
dims=2.^[log2(maxdim):-1:log2(mindim)];
%dims=[512, 256, 128, 64, 32, 16, 8, 4, 2, 1];
numdims=length(dims);
blkid=1;
vrtid=2;
dd=512;
counter=0;

totalweight=0;
totalerr=0;

errmap=zeros(size(a));

for dim=dims
    clear blks;
    [ablks, r, c]=qtgetblk(a, q, dim);
    [bblks, r, c]=qtgetblk(b, q, dim);
    siz=size(ablks);
    numsubblks=size(ablks, 3);
    k=0;

    if ~numsubblks; continue; end;
    
    w=1;%/dim;
    totalweight=totalweight+numsubblks*w;

    ablks=ut_prepblks4bulkproc(ablks);
    bblks=ut_prepblks4bulkproc(bblks);
    step=500;
    eblks=[];
    for i=1:step:numsubblks

        si=i;
        ei=min(i+step-1, numsubblks);
        
        G=256;

        ha=hist(ablks(:, si:ei), 0:G-1); ha=ha/dim/dim;
        hb=hist(bblks(:, si:ei), 0:G-1); hb=hb/dim/dim;
        hab=ut_jhist(ablks(:, si:ei), bblks(:, si:ei));  hab=hab/dim/dim;

        if numsubblks==1; ha=ha'; hb=hb'; end;

        ent_as=-sum(log2(ha.^ha), 1);
        ent_bs=-sum(log2(hb.^hb), 1);
        ent_abs=-sum(log2(hab.^hab), 1);
        e=ent_as+ent_bs-ent_abs;
        nume=2*e;
        deno=ent_as+ent_bs;

        e=round(nume./deno*1000)/1000;

        err=e*w;
        eblks=[eblks, repmat(e, numel(ablks(:, 1)), 1)];
        totalerr=totalerr+sum(err);
    end
    
    eblks=reshape(eblks, siz);
    errmap=qtsetblk(errmap, q, dim+k, eblks);
end

err=totalerr/totalweight;
