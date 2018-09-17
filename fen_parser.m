function out=fen_parser(x, y, fileName)
    fileName = str2double(fileName);
    
    import_imagescsv;
    import_labelscsv;
    
    puzzle = images.Puzzle(fileName);
    index = find(ismember(labels.Puzzle, puzzle));
    fen_string = labels.BoardConfiguration(index);
    
    rows = strsplit(fen_string, '/');
    tmp = strsplit(rows(8));
    rows(8) = tmp(1);

    chessboard = cell(8);
    
    for i = 1:numel(rows)
        curr_row = char(rows(i));
        j_r = 1;
        for j = 1:numel(curr_row)
            
            if isstrprop(curr_row(j), 'digit')
                for k = 1:str2double(curr_row(j))
                    if rem(i, 2) == 0
                        if rem(j_r, 2) == 0
                            chessboard{i, j_r} = '0';
                        else
                            chessboard{i, j_r} = '1';
                        end
                    else
                        if rem(j_r, 2) == 0
                            chessboard{i, j_r} = '1';
                        else
                            chessboard{i, j_r} = '0';
                        end
                    end
                    j_r = j_r + 1;
                end
            else
                chessboard{i, j_r} = curr_row(j);
                j_r = j_r + 1;
            end
        end
    end
    
    out = chessboard{x, y};
end