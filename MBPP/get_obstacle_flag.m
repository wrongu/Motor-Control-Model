% Richard Lange
% October 20, 2011
%
% function to standardize the use of obstacle flags
%
% INPUT:
%   description: one of any of the following strings:
%       none     ==>  0     (open space)
%       clear    ==>  same as 'none'
%       open     ==>  same as 'none'
%       world    ==>  1     (independent of joint movement, but move when
%                            navigating space via treads)
%       self     ==>  2     (always constant with respect to origin, e.g.
%                            the base and treads themselves)
%       constant ==>  same as 'self'
%       static   ==>  same as 'self'
%       arm      ==>  (see 'qualifier')
%       body     ==>  same
%       random   ==>  100   (randomly generated obstacles. used for
%                            testing repeatedly without reloading B)
%       temp     ==>  same
%
%   qualifier: subcategories. leave blank for most.
%       for example, if description is 'arm', a qualifier of (+) integer n
%          would indicate that it is the nth joint in the linkage and is a
%          parent of all links > n
%          To put this another way, changing joint n affects all joints
%          further in the linkage (n+1, n+2, etc)
%
% OUTPUT: the integer to use as the value of 'obstacle' in some cell

function flag = get_obstacle_flag(description, qualifier)
    switch description
        case {'none', 'clear', 'open'}
            flag = 0;
        case 'world'
            flag = 1;
        case {'self', 'constant', 'static'}
            flag = 2;
        case {'arm', 'body'}
            flag = -qualifier;
        case {'random', 'temp'}
            flag = 100;
        otherwise
            flag = 0;
    end
end