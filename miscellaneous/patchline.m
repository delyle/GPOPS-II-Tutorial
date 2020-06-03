function p = patchline(xs,ys,varargin)
% Plot lines as patches (efficiently)
%
% SYNTAX:
%     patchline(xs,ys)
%     patchline(xs,ys,zs,...)
%     patchline(xs,ys,zs,'PropertyName',propertyvalue,...)
%     p = patchline(...)
%
% PROPERTIES: 
%     Accepts all parameter-values accepted by PATCH.
% 
% DESCRIPTION:
%     p = patchline(xs,ys,zs,'PropertyName',propertyvalue,...)
%         Takes a vector of x-values (xs) and a same-sized
%         vector of y-values (ys). z-values (zs) are
%         supported, but optional; if specified, zs must
%         occupy the third input position. Takes all P-V
%         pairs supported by PATCH. Returns in p the handle
%         to the resulting patch object.
%         
% NOTES:
%     Note that we are drawing 0-thickness patches here,
%     represented only by their edges. FACE PROPERTIES WILL
%     NOT NOTICEABLY AFFECT THESE OBJECTS! (Modify the
%     properties of the edges instead.)
%
%     LINUX (UNIX) USERS: One test-user found that this code
%     worked well on his Windows machine, but crashed his
%     Linux box. We traced the problem to an openGL issue;
%     the problem can be fixed by calling 'opengl software'
%     in your <http://www.mathworks.com/help/techdoc/ref/startup.html startup.m>.
%     (That command is valid at startup, but not at runtime,
%     on a unix machine.)
%
% EXAMPLES:
%%% Example 1:
%
% n = 10;
% xs = rand(n,1);
% ys = rand(n,1);
% zs = rand(n,1)*3;
% plot3(xs,ys,zs,'r.')
% xlabel('x');ylabel('y');zlabel('z');
% p  = patchline(xs,ys,zs,'linestyle','--','edgecolor','g',...
%     'linewidth',3,'edgealpha',0.2);
%
%%% Example 2: (Note "hold on" not necessary here!)
%
% t = 0:pi/64:4*pi;
% p(1) = patchline(t,sin(t),'edgecolor','b','linewidth',2,'edgealpha',0.5);
% p(2) = patchline(t,cos(t),'edgecolor','r','linewidth',2,'edgealpha',0.5);
% l = legend('sine(t)','cosine(t)');
% tmp = sort(findobj(l,'type','patch'));
% for ii = 1:numel(tmp)
%     set(tmp(ii),'facecolor',get(p(ii),'edgecolor'),'facealpha',get(p(ii),'edgealpha'),'edgecolor','none')
% end
%
%%% Example 3 (requires Image Processing Toolbox):
%%%   (NOTE that this is NOT the same as showing a transparent image on 
%%%         of the existing image. (That functionality is
%%%         available using showMaskAsOverlay or imoverlay).
%%%         Instead, patchline plots transparent lines over
%%%         the image.)
%
% img = imread('rice.png');
% imshow(img)
% img = imtophat(img,strel('disk',15));
% grains = im2bw(img,graythresh(img));
% grains = bwareaopen(grains,10);
% edges = edge(grains,'canny');
% boundaries = bwboundaries(edges,'noholes');
% cmap = jet(numel(boundaries));
% ind = randperm(numel(boundaries));
% for ii = 1:numel(boundaries)
% patchline(boundaries{ii}(:,2),boundaries{ii}(:,1),...
%     'edgealpha',0.2,'edgecolor',cmap(ind(ii),:),'linewidth',3);
% end
%
% Written by Brett Shoelson, PhD
% brett.shoelson@mathworks.com
% 5/31/2012
% 
% Revisions:
% 6/26 Improved rice.png example, modified FEX image.
%
%
% See also: patch, line, plot
%
% LICENSE, DO NOT ALTER:
% Copyright (c) 2012, The MathWorks, Inc.
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
%     * Neither the name of the The MathWorks, Inc. nor the names
%       of its contributors may be used to endorse or promote products derived
%       from this software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.


[zs,PVs] = parseInputs(varargin{:});
if rem(numel(PVs),2) ~= 0
    % Odd number of inputs!
    error('patchline: Parameter-Values must be entered in valid pairs')
end

% Facecolor = 'k' is (essentially) ignored here, but syntactically necessary
if isempty(zs)
    p = patch([xs(:);NaN],[ys(:);NaN],'k');
else
    p = patch([xs(:);NaN],[ys(:);NaN],[zs(:);NaN],'k');
end

% Apply PV pairs
for ii = 1:2:numel(PVs)
    set(p,PVs{ii},PVs{ii+1})
end
if nargout == 0
    clear p
end

function [zs,PVs] = parseInputs(varargin)
if isnumeric(varargin{1})
    zs = varargin{1};
    PVs = varargin(2:end);
else
    PVs = varargin;
    zs = [];
end