function [ s ] = symbol_mod( const_points, b )
%symbol_mod does PSK modulation for binary input vector
%   b: binary row vector
%   const_points: number of psk points (2, 4 or 8)
%   s: complex symbol vector

if const_points == 2
    % nothing to do here
    s = pskmod(b, 2)   
elseif const_points == 4
    % group by 2 bits
    b = reshape(b, 2, [])
    % msb first
    b = flipud(b)
    dec = []
    % convert binary columns to int
    for i = 1:size(b,2)
       dec = [dec bi2de(b(:,i)')]
    end
    s = pskmod(dec, 4, pi/4)
elseif const_points == 8
    % group by 4 bits
    b = reshape(b, 3, [])
    % msb first
    b = flipud(b)
    dec = []
    % convert binary columns to int
    for i = 1:size(b,2)
        dec = [dec bi2de(b(:,i)')]
    end
    s = pskmod(dec, 8)
end

end

