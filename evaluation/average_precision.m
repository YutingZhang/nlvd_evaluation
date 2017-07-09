function ap = average_precision(rec,prec,method)

if ~exist('method','var') || isempty( method )
    method = 'default';
end

switch method
    case 'default'
        mrec=[0 ; rec ; 1];
        mpre=[0 ; prec ; 0];
        for i=numel(mpre)-1:-1:1
            mpre(i)=max(mpre(i),mpre(i+1));
        end
        i=find(mrec(2:end)~=mrec(1:end-1))+1;
        ap=sum((mrec(i)-mrec(i-1)).*mpre(i));
    case 'voc2007'
        ap=0;
        for t=0:0.1:1
            p=max(prec(rec>=t));
            if isempty(p)
                p=0;
            end
            ap=ap+p/11;
        end
    otherwise
        error( 'unrecognized method for computing AP' );
end

