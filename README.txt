README for multilevel posture-based motor control model
written by Divya Gunasekaran
June 2011

Description: This file contains info on how to run the model and where to find relevant files.

(1) MBPP directory

initMBPP.m 
    Run this script to initialize the memory-based posture planning cell structure.  Currently all variables are hard-coded, but variables that may be changed are cell dimensions (w,l,h) and cell array dimensions (n). This script also initializes an empty map that pairs strings (names of ethological function categories) with hashtable objects.
    You should cd to the MBPP directory and first run this script to initialize the cell structure, task map, and to add the relevant directory paths.
    
findCell.m 
    The other important file in this directory is findCell.m.  This function takes a position in Cartesian coordinates and returns the cell that contains that position either as a triple (the first three integer outputs) or as a single integer (the last output).
    
Other files 
    Other files contained in the MBPP directory are for running the MBPP model as created by Park, Singh, Martin (2006).  To run the original MBPP model, run the script in MBPPmodel.m.

    
(2) Levels directory
    
MainController.m 
    This is the file that runs the multilevel model once the cell structure is initialized.  Currently, it is a script where the inputs (left or right arm, ethological function, and reach target) are simply specified in the first block of code.  This script can easily be converted into a function if so desired.
    This script will search for a movement to the given reach task based on the robot's initial position, generate a new movement if no stored movement can be found, and execute the movement.
    WARNING: It is important to note that currently obstacles must be manually set by setting the obstacle flag of the appropriate cells. This includes cells that contain space occupied by the robot itself.  Therefore, unless you have manually changed the cells that the robot itself occupies, the model considers this free space and may plan a movement through this space, which will result in collisions if the robot enacts the movement. 
    
CheckPostureCollisions.m
    Function to check whether a given posture (i.e. set of joint angles) collides with any obstructions. 

CheckMovement.m
    Function to check whether a given movement (i.e. sequence of postures) will result in a collision. Calls CheckPostureCollisions for each posture.
    
CheckPath.m
    Function to determine whether a path in the workspace (i.e. a sequence of points in Cartesian space) goes through any obstructed cells.
    
StoreMovement.m
    Rates and stores a given movement, all subsequences of that movement, the reverse of the movement, and all subsequences of the reverse of the movement in the given hashtable object.
    
StraightLinePlan.m
    Plans a straight path between a starting and a final point. This is the simple planning algorithm currently used for Level 3 of the multilevel model.
   
   
(3) tcp_udp_ip directory

pnet.c
    Code written by Rydesater et. al. This file contains functions to create TCP sockets and connections to the robot's server.

computeJacobian.m
    Returns a 3x7 Jacobian matrix for the inverse kinematics function. Used in computing the gradient descent of the inverse kinematics function.

EnactPosture.m
    Makes the robot move to a given posture.

euclidDist.m
    Finds the Euclidean distance between two points of equal dimension.
 
Forward Kinematics
    ForwardKinematics_V4.m, written by Dan Muldrew and Richard Lange, is the forward kinematics function for the BrainBot. It gives the position of the robot's end effector in the workspace. This function makes calls to AffineTransform.m and rotationmat3D.m.
    ForwardKinematics_Elbow.m is a modified version of the above and gives the position of the elbow joint in the workspace.
    ForwardKinematics_Shoulder.m is a modified version of the original forward kinematics function and gives the position of the shoulder in the workspace.
    
GenMovement.m
    Function that generates a new movement. It takes a path of workspace points as input and constructs a sequence of postures by finding a suitable posture for each point on the path.  A suitable posture is found by searching in the appropriate cell for stored postures that can be used and then, if an applicable stored posture cannot be found, by creating a new posture using the gradient descent method. If the selected posture results in a collision, all stored postures for the appropriate cell are checked to see if any are collision-free. If one is found, that posture is used in the movement. If one is not found, then no movement is returned and the cell is set as obstructed.
    This is the function largely used in Level 2 and also sometimes in Level 1.

GenPostureDescent.m
    Given a current posture and a reach target, this function generates a new posture that attains the reach target by repeatedly calling gradDescent.m to compute the gradient descent of the forward kinematics function. If a joint angle generated by the gradDescent.m function violates the joint angle constraints of the robot, the update is undone at that joint.  We also keep track of the number of times the "new" generated posture is the same as the previously generated posture and halt the function when a limit is reached.
    
getAngle.m
    Returns the position of a given servo in radians.
 
GetCurrPosture.m
    Returns the positions of all of the robot's servos in radians. Calls getAngle.m for each servo.
    
GetPosturePosition.m
    Returns the position of the robot's end effector given which arm (right or left) and the joint angles for that arm.  Calls ForwardKinematics_V4.m.
    
gradDescent.m
    Computes one step of the gradient descent method. Calls GetPosturePosition, euclidDist, and computeJacobian. 
    NOTE: Currently, torso yaw and torso pitch 1 and 2 are kept constant because their inclusion results in large torso movements and unnatural arm movements.  Some kind of "potential field" or opposing force needs to be included to reduce torso movements.
    
moveServo.m and moveServoHelper.m
    Makes the robot move a given servo to the given servo position.  Action will not be executed if the given position violates the robot's range of motion.

RateMovement.m
    Assigns a rating to a movement based on spatial error cost (how closely the movement attains the reach target) and a travel cost (absolute angular displacement).  The spatial error cost is simply the Euclidean distance between the final position of the robot's end effector and the reach target. Travel cost is calculated by calling TravelCost.m. Spatial error cost and travel cost are taken from Rosenbaum et. al (2001).

selectPosture1.m
    Given a position in the workspace and an initial posture, this function searches across all postures stored in the cell that contains the given position, rates each stored posture according to a spatial error cost and travel cost (same as described above for RateMovement.m), and returns the posture with the best rating.

TravelCost.m
    Computes the travel cost of angular displacement between two postures. Based on equations developed by Rosenbaum et. al (2001).
    
sendStr.m
    Sends a string to the robot's server through a socket connection. Calls a function in pnet.c.

Other files
    Files such as wakeup.m, forwardArm.m, straightElbow.m, waveElbow.m are for demo purposes to show the robot moving.
    Some of the files such as serverLagTest.m, speedTest.m, testAngles.m are for testing purposes.
    Other files are part of the tcp_udp_ip package that came with pnet.c or are saved figures or workspaces. 
    

(4) HashTable directory

HashTable.m
    Creates a HashTable class with functions pertaining to the creation, expansion, insertion, and lookup of/in the HashTable object. This HashTable class is not a generic hash table; rather, it is specific to the needs of the multilevel motor control model.
    
dlnode.m
    Provided by Matlab. Each entry in the HashTable is a doubly linked list.  This file contains code for the creation, deletion, insertion of/in doubly linked lists. It is a generic doubly linked list.
    
ReturnTable.m
    Finds and returns the hash table associated with a given ethological function. If no such hash table exists, a new one is created and returned.
    
    
(5) D star lite directory
This directory contains files for D* Lite algorithm.
    
A_ComputePath.m
    The main file where the D* Lite algorithm is executed. Calls A_CalculateKey.m, A_Succ, A_UpdateCell.m, and priority queue functions (see section 7).  For our application of D* Lite, cells are used as nodes and the algorithm plans between the center of cells. Returns an optimal path between two points. This is the planning used in Level 4 of the model.
   
A_CalculateKey.m
    Returns the two keys for a given node.

A_Succ.m
    Returns the adjacent nodes for a given node. Since our model is for 3D space and we allow paths to cut across diagonals, a maximum of 26 adjacent nodes may be returned.
    
A_UpdateCell.m
    Updates a node's rhs value and keys.
    
A_ResetCosts.m and A_ResetObstacles.m
    These functions reset the rhs and goal costs of each node and reset the obstacle flag for all cells to be 0, respectively.
    

(6) D star directory

This directory contains files to execute the Field D* algorithm for 3D space.  None of the functions are currently used because the code as it stands took an exorbitant amount of time to run and was not generating optimal paths.  This algorithm was originally intended to be used for Level 4. It differs from D* Lite in that it can plan through faces and edges of cells, whereas with D* Lite we are just planning through the center of cells.


(7) PriorityQueue directory
    
These files were written by Andrea Tagliasacchi and modified by Divya Gunasekaran.  The functions in this directory are for creating, deleting, popping, inserting, peeking of/in a min or max heap-based priority queue.  We use a min priority queue with functions in D star lite directory (section 5).


(8) PCA directory

These files were written to run Principle Component Analysis on a set of data.  However, PCA is not currently used in our model so these functions are not currently used.  Furthermore, Matlab has a PCA function that could potentially be used in place of these functions.

    
    
