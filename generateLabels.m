root_dir = '/path-to-data/FDDB/';
labels_dir = [root_dir 'labels/'];
images_dir = [root_dir 'images/'];
train_file = [root_dir 'train.txt'];
f_train = fopen(train_file,'w');

for i = 1:10
	fold_file = [root_dir 'FDDB-folds/FDDB-fold-' sprintf('%02d',i) '-rectList.txt'];
	A = importdata(fold_file);
	for j = 1:length(A.textdata)
		img_fname = A.textdata{j};
		img = imread(img_fname);
		img_width = size(img,2);
		img_height = size(img,1);
		temp = strsplit(img_fname,'.');
		labels_fname = [strrep(temp{1},'images','labels') '.txt'];
		labels_fname_split = strsplit(labels_fname,'/');
		month_dir = [labels_dir labels_fname_split{end-4} '/' labels_fname_split{end-3} '/'];
		date_dir = [month_dir labels_fname_split{end-2} '/'];
		size_dir = [date_dir labels_fname_split{end-1} '/'];
		if ~exist(month_dir,'dir')
			system(['mkdir ' month_dir]);
		end
		if ~exist(date_dir, 'dir')
			system(['mkdir ' date_dir]);
		end
		if ~exist(size_dir,'dir')
			system(['mkdir ' size_dir]);
		end
		if ~exist(labels_fname)
			f = fopen(labels_fname,'w');
			fprintf(f_train,'%s\n',img_fname);
		else
			f = fopen(labels_fname,'a');
		end
		x = (A.data(j,1) + A.data(j,3))/(2*img_width);
		w = (A.data(j,3) - A.data(j,1))/img_width;
		y = (A.data(j,2) + A.data(j,4))/(2*img_height);
		h = (A.data(j,4) - A.data(j,2))/img_height;
		fprintf(f,'%d %f %f %f %f\n',0,x,y,w,h);
		fclose(f);
	end
end
