src_ip(Packet_Name,Src_IP) :- 
    packet(Packet_Name,List),
    [Src_IP|_]=List.
dest_ip(Packet_Name,Dest_IP) :- 
    packet(Packet_Name,List),
    [_|[Dest_IP|_]]=List.

adapter_num(Packet_Name,Adapter_Num) :- 
    packet(Packet_Name,List),
    [_|[_|[Adapter_Num|_]]]=List.

protocol_type(Packet_Name,Protocol_Type) :- 
    packet(Packet_Name,List),
    [_|[_|[_|[Protocol_Type|_]]]]=List.

icmpv6_type(Packet_Name,Icmpv6_Type) :- 
    packet(Packet_Name,List),
    [_|[_|[_|[_|[Icmpv6_Type|_]]]]]=List.

icmpv6_msgCode(Packet_Name,Icmpv6_MsgCode) :- 
    packet(Packet_Name,List),
	[_|[_|[_|[_|[_|[Icmpv6_MsgCode|_]]]]]]=List.

vlanId(Packet_Name,VlanId) :- 
    packet(Packet_Name,List),
    [_|[_|[_|[_|[_|[_|[VlanId|_]]]]]]]=List.

tcpSrc(Packet_Name,TCPSrc) :- 
    packet(Packet_Name,List),
    [_|[_|[_|[_|[_|[_|[_|[TCPSrc|_]]]]]]]]=List.
    
tcpDst(Packet_Name,TCPDst) :- 
    packet(Packet_Name,List),
    [_|[_|[_|[_|[_|[_|[_|[_|[TCPDst|_]]]]]]]]]=List.

udpSrc(Packet_Name,UDPSrc) :- 
    packet(Packet_Name,List),
    [_|[_|[_|[_|[_|[_|[_|[_|[_|[UDPSrc|_]]]]]]]]]]=List.
    
udpDst(Packet_Name,UDPDst) :- 
    packet(Packet_Name,List),
    [_|[_|[_|[_|[_|[_|[_|[_|[_|[_|[UDPDst|_]]]]]]]]]]]=List.
    
ipv6Src(Packet_Name,IPV6Src) :- 
    packet(Packet_Name,List),
    [_|[_|[_|[_|[_|[_|[_|[_|[_|[_|[_|[IPV6Src|_]]]]]]]]]]]]=List.      
    
ipv6Dst(Packet_Name,IPV6Dst) :- 
    packet(Packet_Name,List),
    [_|[_|[_|[_|[_|[_|[_|[_|[_|[_|[_|[_|[IPV6Dst|_]]]]]]]]]]]]]=List.

icmpType(Packet_Name,ICMPType) :- 
    packet(Packet_Name,List),
    [_|[_|[_|[_|[_|[_|[_|[_|[_|[_|[_|[_|[_|[ICMPType|_]]]]]]]]]]]]]]=List.

icmpCode(Packet_Name,ICMPCode) :- 
    packet(Packet_Name,List),
    [_|[_|[_|[_|[_|[_|[_|[_|[_|[_|[_|[_|[_|[_|[ICMPCode|_]]]]]]]]]]]]]]]=List.
protocolID(Packet_Name,ProtocolID) :-
    packet(Packet_Name,List),
    [_|[_|[_|[_|[_|[_|[_|[_|[_|[_|[_|[_|[_|[_|[_|[ProtocolID|_]]]]]]]]]]]]]]]]=List.

/*	RULE BASE SYNTAX
 * isAdapterAccepted(AdapterName) 
 * isProtocolIDAccepted(ProtocolId)
 * isVlanIDAccepted(VlanId)
 * isSrcIPAccepted(SrcIP) 
 * isDstIPAccepted(DstIP)
 * isTCPSrcAccepted(TCPPortNo)
 * isTCPDstAccepted(TCPPortNo)
 * isUDPSrcAccepted(UDPPortNo)
 * isUDPDstAccepted(UDPPortNo)
 * isIPV6SrcAccepted(IPV6SrcAddr)    
 * isIPV6DstAccepted(IPV6DstAddr)
 * isICMPTypeAccepted(Type)
 * isICMPCodeAccepted(Code)
 * isICMPV6TypeAccepted(Type)
 * isICMPV6CodeAccepted(Code)
 * */
/*------------Rule to see if adapter is acceptable------------*/
isAdapterAccepted(AdapterName) :- 
    accept(X),	%Check for clauses in accept predicate
    sub_string(X,_,_,_,'adapter'),	%Check if adapter is present in clause
    not(sub_string(AdapterName,_,_,_,"*")),
    (
    	%There's a direct match
	    (
		     sub_string(X,_,_,_,AdapterNamePresent),
		     AdapterNamePresent=AdapterName
	    )
	    ;
    	%Adapter present between given range
	    (
		     isExprARange(X),
		     sub_string(X,8,1,_,LeftOfRange),
		     sub_string(X,10,1,_,RightOfRange),
		     char_code(LeftOfRange,LeftOfRangeAscii),
		     char_code(RightOfRange,RightOfRangeAscii),
		     char_code(AdapterName,AdapterAscii),
		     AdapterAscii>=LeftOfRangeAscii,
		     AdapterAscii=<RightOfRangeAscii
	    )
	    ;
    	%if any is present accept all adapters
	    (   
	    	 sub_string(X,8,3,_,'any')
	    )
    ).

    /*------------Rule to see if ProtocolID is acceptable------------*/
	isProtocolIDAccepted(ProtocolId) :- 
	    accept(X),
    	sub_string(X,_,_,_,'ether'),
    	sub_string(X,_,_,_,'proto'),
    	not(sub_string(ProtocolId,_,_,_,"*")),
	 (   
        (
	      (
	        sub_string(X,_,_,_,'ether proto'),	
	        % no vlan id present in clause (ether proto and no vid)
	        sub_string(X,_,_,_,PresentProtocolID),
	        sub_string(PresentProtocolID,_,_,_,ProtocolId)
	      )
	    	;
	      % vlan id present in clause (ether vid _ proto )
	      (   
		sub_string(X,_,_,_,'proto'),
		 sub_string(X,_,_,_,'vid'),
	          %Direct match now
	          sub_string(X,_,_,_,PresentProtocolID),
	          sub_string(PresentProtocolID,_,_,_,ProtocolId)
	      )
	    )
    	;
    	(   
        	sub_string(X,_,_,_,'any')
        )
     )
    	.

/*------------Rule to see if VlanID is acceptable------------*/
	isVlanIDAccepted(VlanId) :- 
	    accept(X),   
	    not(sub_string(VlanId,_,_,_,"*")),
         sub_string(X,0,9,_,'ether vid'),
      (   
	    (   
	    		%direct match
	      (
	          sub_string(X,Start,_,_,PresentVlanID),
	          sub_string(X,ProtoIndex,5,_,'proto'),
	          Start<ProtoIndex,
	          PresentVlanID = VlanId
	      )
	      ;
	      (
	    	%VId is in range format in clause(ether vid x-y)
	          sub_string(X,10,Len,_,Range),
	          isExprARange(Range),
	          Start is 10+Len,
	          sub_string(X,Start,1,_,' '),
	          sub_string(Range,0,Len2,_,LeftOfRange),%LeftOfRange is Left number in string Format
	          Start2 is 1+Len2,
	          not(sub_string(Range,Start2,1,_,'-')),
	          Start3 is Start2,
	          sub_string(Range,Start3,Len3,_,RightOfRange),%RightOfRange same as LeftOfRange
	          Start4 is 1+Len3,
	          sub_string(Range,Start4,_,0,_),
	          atom_number(LeftOfRange,LeftNum),
	          atom_number(RightOfRange,RightNum),
	          atom_number(VlanId,VlanIdNum),
	          LeftNum=<VlanIdNum,	%Check if VLAn id lies within range
	          RightNum>=VlanIdNum
	      )
	    )
        ;
            (   
                sub_string(X,_,_,_,'any')
            )
         ).
/*------------------SRC IP--------------------*/
	isSrcIPAccepted(SrcIP) :- 
    	accept(X),
        atom_length(X,XLength),	%XLength stores length of X
    	sub_string(X,_,_,_,'ip'),
    	not(sub_string(SrcIP,_,_,_,"*")),
    	(   
        (
    		%src ip syntax:- ip src addr or src addr dst addr
          (
            sub_string(X,SrcIndex,3,_,'src'),
            Start1 is SrcIndex+9,
                (   
                 %src and dst addr(' ' signifies space before dst)
                  (
                    sub_string(X,Start2,1,_,' '),
                    Start2 >= Start1,
                    Length is Start2-Start1,
                    sub_string(X,Start1,Length,_,SrcIPList),
                      (   
                      	(
                        	isExprARange(SrcIPList),
                            isIPInRange(SrcIP,SrcIPList)
                        )
                      	;
                      	(
                    		sub_string(SrcIPList,_,_,_,SrcIP)                        	
                        )
                      )

                  );
                 %only src addr present
                 (	
                     not(sub_string(X,_,3,_,'dst')),
                     sub_string(X,_,3,_,'src'),
                     (
                     (
                       StrLen is XLength - Start1
                     )
                     ;
                     (  
                      not(sub_string(X,_,3,_,'dst')),
                      sub_string(X,ProtoIndex,_,_,'proto'),
                      StrLen is ProtoIndex - Start1 -1
                     )
                     ),
                     sub_string(X,Start1,StrLen,_,SrcIPList),
                     (   
                      	(
                        	isExprARange(SrcIPList),
                            isIPInRange(SrcIP,SrcIPList)
                        )
                      	;
                      	(
                    		sub_string(SrcIPList,_,_,_,SrcIP)                        	
                        )
                      )
                 )
               )
          );
          %deals with the case when only addr is written
           (   
                not(sub_string(X,_,3,_,'dst')),
                not(sub_string(X,_,3,_,'src')),
                sub_string(X,Start,4,_,'addr'),
                Start2 is Start+5,
               	StrLen is XLength - Start2,
                sub_string(X,Start2,StrLen,_,SrcIPList),
               	(   
                      	(
                        	isExprARange(SrcIPList),
                            isIPInRange(SrcIP,SrcIPList)
                        )
                      	;
                      	(
                    		sub_string(SrcIPList,_,_,_,SrcIP)                        	
                        )
                      )
           )
        )
        ;
            (   
                sub_string(X,_,_,_,'any')
            )
       ).


    %------DST IP
	isDstIPAccepted(DstIP) :- 
    	accept(X),
    	atom_length(X,XLength),
    	sub_string(X,0,2,_,'ip'),
    	not(sub_string(DstIP,_,_,_,"*")),
     (   
        (
    %dst ip syntax:- ip dst addr or src addr dst addr 
          (
            sub_string(X,_,3,_,'dst'),
                (   
                 %both src and dst addr present
                  (
                  	sub_string(X,SrcIndex,3,_,'src'),
            		Start1 is SrcIndex+9,
                    sub_string(X,Start2,1,_,' '),
                    Start2 >= Start1,
                     DstStart is Start2 + 10,
                    (
                      (   
                      	sub_string(X,ProtoIndex,_,_,'proto'),
                      	Length is ProtoIndex-DstStart+1
                      )
                      ;
                      (   
                        not(sub_string(X,_,_,_,'proto')),
                        Length is XLength - DstStart
                      )  
                    ),
                    sub_string(X,DstStart,Length,_,DstIPList),
                      (   
                      /*-------Checking if there is a range------*/
                      	(
                        	isExprARange(DstIPList),
                            isIPInRange(DstIP,DstIPList)
                        )
                      	;
                      /*-------Checking if there is a direct match(i.e. discrete or list)------*/
                      	(
                    		sub_string(DstIPList,_,_,_,DstIP)                        	
                        )
                      )

                  );
                /*-----------only dst addr present------------*/
                 (
                     not(sub_string(X,_,3,_,'src')),
                     sub_string(X,DstStartTemp,3,_,'dst'),
                     DstStart is DstStartTemp + 9,
                     StrLen is XLength - DstStart,
                     sub_string(X,DstStart,StrLen,_,DstIPList),
                     (   
                      	(
                        	isExprARange(DstIPList),
                            isIPInRange(DstIP,DstIPList)
                        )
                      	;
                      	(
                    		sub_string(DstIPList,_,_,_,DstIP)                        	
                        )
                      )
                 )
               )
          );
        /*--------deals with the case when only addr is written-------*/
           (   
                not(sub_string(X,_,3,_,'dst')),
                not(sub_string(X,_,3,_,'src')),
                sub_string(X,Start,4,_,'addr'),
                Start2 is Start+5,
               	StrLen is XLength - Start2,
                sub_string(X,Start2,StrLen,_,DstIPList),
               	(   
                      	(
                        	isExprARange(DstIPList),
                            isIPInRange(DstIP,DstIPList)
                        )
                      	;
                      	(
                    		sub_string(DstIPList,_,_,_,DstIP)                        	
                        )
                      )
           )
        );
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).




/*----------function to insert element in a list---------*/
	insert(X,[],[X]).
	insert(X,[H|Tail],[H|NewTail]):-
    insert(X,Tail,NewTail).
/*-----------converts a list containing numbers as strings into numbers--------*/
    cnvrtStrListToNumList(IPContents,IPContentsList) :-
        [Elem1|RemPart1] = IPContents,
        [Elem2|RemPart2] = RemPart1,
        [Elem3|RemPart3] = RemPart2,
        [Elem4|_] = RemPart3,
        atom_number(Elem1,NewElem1),
        atom_number(Elem2,NewElem2),
        atom_number(Elem3,NewElem3),
        atom_number(Elem4,NewElem4),
        insert(NewElem1,[],W), 
        insert(NewElem2,W,X),
        insert(NewElem3,X,Y),
        insert(NewElem4,Y,IPContentsList).
/*---------------checks if a given IP lies between the given range of IPs-----------------*/
	isIPInRange(IP,Range) :- 
    	isExprARange(Range),
    	sub_string(Range,HyphenIndex,1,_,'-'),
    	atom_length(Range,RangeLength),
    	LeftIPLength is HyphenIndex,
    	RightIPLength is RangeLength-LeftIPLength-1,
    	sub_string(Range,0,LeftIPLength,_,LeftIP),
    	RightIPIndex is HyphenIndex+1,
    	sub_string(Range,RightIPIndex,RightIPLength,_,RightIP),
    	split_string(LeftIP,".","", LeftIPContents),
    	split_string(RightIP,".","", RightIPContents),
    	split_string(IP,".","", GivenIPContents),
    	cnvrtStrListToNumList(LeftIPContents,LeftIPContentsList),
    	cnvrtStrListToNumList(GivenIPContents,GivenIPContentsList),
    	cnvrtStrListToNumList(RightIPContents,RightIPContentsList),
    	isIPALessThanB(LeftIPContentsList,GivenIPContentsList),
    	isIPALessThanB(GivenIPContentsList,RightIPContentsList).
  
/*--------------takes list of 2 ips and tell if one ip is less than other----------------*/
	isIPALessThanB(IP_A,IP_B) :- 
    	[H1|T1] = IP_A,
    	[H2|T2] = IP_B,
		[H3|T3] = T1,
    	[H4|T4] = T2,
		[H5|T5] = T3,
    	[H6|T6] = T4,
		[H7|_] = T5,
    	[H8|_] = T6,
     (   
        (H1 < H2);
    		(   
            	( H1 = H2 ),
                	(   
                    	( H3<H4  );
                    		(   
                            	(H3=H4),
                                	(   
                                    	(H5<H6);
                                    		(   
                                            	(H5=H6),
                                                (H7<H8)
                                            )
                                    )
                            )
                    )
            )
	 ).
     %Checks if TCP Src is accepted
	isTCPSrcAccepted(TCPPortNo) :- 
    	accept(X),
    	atom_length(X,XLength),
    	not(sub_string(TCPPortNo,_,_,_,"*")),
    	sub_string(X,_,3,_,'tcp'),
    	sub_string(X,Start,3,_,'src'),
    	(
        (   
    	ListStart is Start+9,
    	Length is XLength - ListStart,
    	sub_string(X,ListStart,Length,_,TCPList),
    		(   
    		 %Direct Match
              (   
              	sub_string(TCPList,_,_,_,TCPPortNo)
              );
    		 %TCP Port no is in list
              ( 
              	isExprARange(TCPList),
                atom_length(TCPList,ListLength),
                sub_string(TCPList,HyphenIndex,1,_,'-'),
                sub_string(TCPList,0,HyphenIndex,_,LeftOfRange),
                StartOfRight is HyphenIndex + 1,
                LengthOfRight is ListLength - StartOfRight,
                sub_string(TCPList,StartOfRight,LengthOfRight,_,RightOfRange),
                atom_number(LeftOfRange,LeftNum),
                atom_number(RightOfRange,RightNum),
                atom_number(TCPPortNo,TCPPortNum),
                LeftNum=<TCPPortNum,
                RightNum>=TCPPortNum
              )
            ));
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).
    		
	isTCPDstAccepted(TCPPortNo) :- 
    	accept(X),
    	atom_length(X,XLength),
    	not(sub_string(TCPPortNo,_,_,_,"*")),
    	sub_string(X,_,3,_,'tcp'),
    	sub_string(X,Start,3,_,'dst'),
    (   
     (   
    	%Start of the list of port no is same and length depends upon whether src is present or not
    	ListStart is Start+9,
    	(   
          (
          	sub_string(X,SrcStart,3,_,'src'),
            Length is SrcStart - ListStart -1
          )
          ;
          (   
          	Length is XLength - ListStart
          )
        ),
    	sub_string(X,ListStart,Length,_,TCPList),
    		(   
              (   
              	sub_string(TCPList,_,_,_,TCPPortNo)
              );
              ( 
              	isExprARange(TCPList),
                atom_length(TCPList,ListLength),
                sub_string(TCPList,HyphenIndex,1,_,'-'),
                sub_string(TCPList,0,HyphenIndex,_,LeftOfRange),
                StartOfRight is HyphenIndex + 1,
                LengthOfRight is ListLength - StartOfRight,
                sub_string(TCPList,StartOfRight,LengthOfRight,_,RightOfRange),
                atom_number(LeftOfRange,LeftNum),
                atom_number(RightOfRange,RightNum),
                atom_number(TCPPortNo,TCPPortNum),
                LeftNum=<TCPPortNum,
                RightNum>=TCPPortNum
              )
            )
        )
       ;
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).
/*-----------------------UDP SRC and DST accept------------------*/
isUDPSrcAccepted(UDPPortNo) :- 
    	accept(X),
    	atom_length(X,XLength),
    	not(sub_string(UDPPortNo,_,_,_,"*")),
    	sub_string(X,_,3,_,'udp'),
    	sub_string(X,Start,3,_,'src'),
    (   
     (   
    	ListStart is Start+9,
    	Length is XLength - ListStart,
    	sub_string(X,ListStart,Length,_,UDPList),
    		(   
              (   
              	sub_string(UDPList,_,_,_,UDPPortNo)
              );
              ( 
              	isExprARange(UDPList),
                atom_length(UDPList,ListLength),
                sub_string(UDPList,HyphenIndex,1,_,'-'),
                sub_string(UDPList,0,HyphenIndex,_,LeftOfRange),
                StartOfRight is HyphenIndex + 1,
                LengthOfRight is ListLength - StartOfRight,
                sub_string(UDPList,StartOfRight,LengthOfRight,_,RightOfRange),
                atom_number(LeftOfRange,LeftNum),
                atom_number(RightOfRange,RightNum),
                atom_number(UDPPortNo,UDPPortNum),
                LeftNum=<UDPPortNum,
                RightNum>=UDPPortNum
              )
            )
     )
    ;
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).
	isUDPDstAccepted(UDPPortNo) :- 
    	accept(X),
    	atom_length(X,XLength),
    	not(sub_string(UDPPortNo,_,_,_,"*")),
    	sub_string(X,_,3,_,'udp'),
    	sub_string(X,Start,3,_,'dst'),
    (   
     (   
    	ListStart is Start+9,
    	(   
          (
          	sub_string(X,SrcStart,3,_,'src'),
            Length is SrcStart - ListStart -1
          )
          ;
          (   
          	Length is XLength - ListStart
          )
        ),
    	sub_string(X,ListStart,Length,_,UDPList),
    		(   
              (   
              	sub_string(UDPList,_,_,_,UDPPortNo)
              );
              ( 
              	isExprARange(UDPList),
                atom_length(UDPList,ListLength),
                sub_string(UDPList,HyphenIndex,1,_,'-'),
                sub_string(UDPList,0,HyphenIndex,_,LeftOfRange),
                StartOfRight is HyphenIndex + 1,
                LengthOfRight is ListLength - StartOfRight,
                sub_string(UDPList,StartOfRight,LengthOfRight,_,RightOfRange),
                atom_number(LeftOfRange,LeftNum),
                atom_number(RightOfRange,RightNum),
                atom_number(UDPPortNo,UDPPortNum),
                LeftNum=<UDPPortNum,
                RightNum>=UDPPortNum
              )
            )
     )
    ;
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).

isIPV6SrcAccepted(IPV6SrcAddr) :- 
    accept(X),
    sub_string(X,_,4,_,'ipv6'),
    not(sub_string(IPV6SrcAddr,_,_,_,"*")),
    atom_length(X,XLength),
   (   
    (   
    (
    /*------------ipv6 src addr or ipv6 src addr dst addr--------------*/
    (
      sub_string(X,SrcStart,3,_,'src'),
      Start is SrcStart + 9,
      (
      	/*-----------ipv6 src addr dst addr---------------*/
      	(   
        	sub_string(X,DstStart,3,_,'dst'),
            Length is DstStart - SrcStart -1
        )
        ;
      	(   
        	/*-------------ipv6 src addr only----------------*/
        	not(sub_string(X,_,3,_,'dst')),
            not(sub_string(X,_,5,_,'proto')),
            Length is XLength - Start
        )
      	;
      	(   
        	/*-------------ipv6 src addr and proto----------------*/
        	not(sub_string(X,_,3,_,'dst')),
            sub_string(X,ProtoIndex,_,_,'proto'),
            Length is ProtoIndex - Start -1
        )
      ),
      sub_string(X,Start,Length,_,IPSrcList),
        (
        /*---------Direct Match (discrete atom or list of values)--------*/
          (   
          	sub_string(IPSrcList,_,_,_,IPV6SrcAddr)
          )
          /*;*/
        /*---------Range of Values------------*/
          /*( 
          
          )*/
        )
    )
     ;
    /*----------ipv6 addr----------*/
    (   
    	sub_string(X,AddrLocn,_,_,'addr'),
        not(sub_string(X,_,_,_,'src')),
        not(sub_string(X,_,_,_,'dst')),
        Start is AddrLocn + 5,
        Length is XLength - Start,
     	sub_string(X,Start,Length,_,IPSrcList),
        (
        /*---------Direct Match (discrete atom or list of values)--------*/
          (   
          	sub_string(IPSrcList,_,_,_,IPV6SrcAddr)
          )
          /*;*/
        /*---------Range of Values------------*/
          /*( 
          
          )*/
        )
    )
    )
    )
   ;
    	(   
        	sub_string(X,_,_,_,'any')
        )
    ).
    
isIPV6DstAccepted(IPV6DstAddr) :- 
    accept(X),
    sub_string(X,_,4,_,'ipv6'),
    not(sub_string(IPV6DstAddr,_,_,_,"*")),
    atom_length(X,XLength),
    (   
    (   
    (
    /*------------ipv6 dst addr or ipv6 src addr dst addr--------------*/
    (
      sub_string(X,_,3,_,'src'),
      sub_string(X,DstStart,3,_,'dst'),
      Start is DstStart + 9,
      (
      	/*-----------ipv6 src addr dst addr or---------------*/
        	/*-------------ipv6 src addr only, length remains same----------------*/
            (
            	not(sub_string(X,_,_,_,'proto')),
            	Length is XLength - Start
            )
      		;
      		(   
            	sub_string(X,ProtoIndex,_,_,'proto'),
                Length is ProtoIndex-DstStart+1
            )
      ),
      sub_string(X,Start,Length,_,IPDstList),
        (
        /*---------Direct Match (discrete atom or list of values)--------*/
          (   
          	sub_string(IPDstList,_,_,_,IPV6DstAddr)
          )
          /*;*/
        /*---------Range of Values------------*/
          /*( 
          
          )*/
        )
    )
     ;
    /*----------ipv6 addr----------*/
    (   
    	sub_string(X,AddrLocn,_,_,'addr'),
        not(sub_string(X,_,_,_,'src')),
        not(sub_string(X,_,_,_,'dst')),
        Start is AddrLocn + 5,
        Length is XLength - Start,
     	sub_string(X,Start,Length,_,IPDstList),
        (
        /*---------Direct Match (discrete atom or list of values)--------*/
          (   
          	sub_string(IPDstList,_,_,_,IPV6DstAddr)
          )
          /*;*/
        /*---------Range of Values------------*/
          /*( 
          
          )*/
        )
    )
    )
    )
    ;
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).
isICMPTypeAccepted(Type) :- 
    accept(X),
    atom_length(X,XLength),
    sub_string(X,_,_,_,'icmp'),
    not(sub_string(Type,_,_,_,"*")),
    not(sub_string(X,_,_,_,'icmpv6')),
    sub_string(X,StartTemp,_,_,'type'),
    (   
    (   
    Start is StartTemp + 5,
    (
    	(
        	sub_string(X,CodeStart,_,_,'code'),
            Length is CodeStart - Start - 1
        )
    	;   
    	(   
        	not(sub_string(X,_,_,_,'code')),
            Length is XLength - Start
        )
    ),
    sub_string(X,Start,Length,_,Type)
    );
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).
    
isICMPCodeAccepted(Code) :- 
    accept(X),
    atom_length(X,XLength),
    not(sub_string(Code,_,_,_,"*")),
    sub_string(X,_,_,_,'icmp'),
    not(sub_string(X,_,_,_,'icmpv6')),
    sub_string(X,StartTemp,_,_,'code'),
    (   
    (   
    Start is StartTemp + 5,
    (
            Length is XLength - Start
    ),
    sub_string(X,Start,Length,_,Code)
    );
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).
/*----------------ICMPV6 type and code accepted------------------*/
isICMPV6TypeAccepted(Type) :- 
    accept(X),
    atom_length(X,XLength),
    not(sub_string(Type,_,_,_,"*")),
    sub_string(X,_,_,_,'icmpv6'),
    sub_string(X,StartTemp,_,_,'type'),
    (   
    (   
    Start is StartTemp + 5,
    (
    	(
        	sub_string(X,CodeStart,_,_,'code'),
            Length is CodeStart - Start - 1
        )
    	;   
    	(   
        	not(sub_string(X,_,_,_,'code')),
            Length is XLength - Start
        )
    ),
    sub_string(X,Start,Length,_,Type)
    );
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).
    
isICMPV6CodeAccepted(Code) :- 
    accept(X),
    atom_length(X,XLength),
    not(sub_string(Code,_,_,_,"*")),
    sub_string(X,_,_,_,'icmpv6'),
    sub_string(X,StartTemp,_,_,'code'),
    (   
    (   
    Start is StartTemp + 5,
    (
            Length is XLength - Start
    ),
    sub_string(X,Start,Length,_,Code)
    );
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).

/*
 * 
 * Query to check if a adapter is accepted
 * isAdapterAccepted("A"),!. //This ! tells prolog to stop looking after u find a match
 */ 
isExprAList(X) :- chPresentInStr(',',X).
isExprARange(X) :- chPresentInStr('-',X).
isExprADiscrValue(X) :- not(isExprAList(X)),not(isExprARange(X)).
chPresentInStr(Ch,Str) :- sub_atom_icasechk(Str,_,Ch).

/*	RULE BASE SYNTAX
 * isAdapterRejected(AdapterName) 
 * isProtocolIDRejected(ProtocolId)
 * isVlanIDRejected(VlanId)
 * isSrcIPRejected(SrcIP) 
 * isDstIPRejected(DstIP)
 * isTCPSrcRejected(TCPPortNo)
 * isTCPDstRejected(TCPPortNo)
 * isUDPSrcRejected(UDPPortNo)
 * isUDPDstRejected(UDPPortNo)
 * isIPV6SrcRejected(IPV6SrcAddr)    
 * isIPV6DstRejected(IPV6DstAddr)
 * isICMPTypeRejected(Type)
 * isICMPCodeRejected(Code)
 * isICMPV6TypeRejected(Type)
 * isICMPV6CodeRejected(Code)
 * */
/*------------Rule to see if adapter is rejectable------------*/
isAdapterRejected(AdapterName) :- 
    reject(X),	%Check for clauses in reject predicate
    sub_string(X,_,_,_,'adapter'),	%Check if adapter is present in clause
    not(sub_string(AdapterName,_,_,_,"*")),
    (
    	%There's a direct match
	    (
		     sub_string(X,_,_,_,AdapterNamePresent),
		     AdapterNamePresent=AdapterName
	    )
	    ;
    	%Adapter present between given range
	    (
		     isExprARange(X),
		     sub_string(X,8,1,_,LeftOfRange),
		     sub_string(X,10,1,_,RightOfRange),
		     char_code(LeftOfRange,LeftOfRangeAscii),
		     char_code(RightOfRange,RightOfRangeAscii),
		     char_code(AdapterName,AdapterAscii),
		     AdapterAscii>=LeftOfRangeAscii,
		     AdapterAscii=<RightOfRangeAscii
	    )
	    ;
    	%if any is present reject all adapters
	    (   
	    	 sub_string(X,8,3,_,'any')
	    )
    ).

    /*------------Rule to see if ProtocolID is rejectable------------*/
	isProtocolIDRejected(ProtocolId) :- 
	    reject(X),
	    not(sub_string(ProtocolId,_,_,_,"*")),
    	sub_string(X,_,_,_,'ether'),
    	sub_string(X,_,_,_,'proto'),
	 (   
        (
	      (
	        sub_string(X,_,_,_,'ether proto'),	
	        % no vlan id present in clause (ether proto and no vid)
	        sub_string(X,_,_,_,PresentProtocolID),
		sub_string(PresentProtocolID,_,_,_,ProtocolId)
	      )
	    	;
	      % vlan id present in clause (ether vid _ proto )
	      (   
		sub_string(X,_,_,_,'proto'),
		 sub_string(X,_,_,_,'vid'),
	          %Direct match now
	          sub_string(X,_,_,_,PresentProtocolID),
	          sub_string(PresentProtocolID,_,_,_,ProtocolId)
	      )
	    )
    	;
    	(   
        	sub_string(X,_,_,_,'any')
        )
     )
    	.

/*------------Rule to see if VlanID is rejectable------------*/
	isVlanIDRejected(VlanId) :- 
	    reject(X),   
	    not(sub_string(VlanId,_,_,_,"*")),
         sub_string(X,0,9,_,'ether vid'),
      (   
	    (   
	    		%direct match
	      (
	          sub_string(X,Start,_,_,PresentVlanID),
	          sub_string(X,ProtoIndex,5,_,'proto'),
	          Start<ProtoIndex,
	          PresentVlanID = VlanId
	      )
	      ;
	      (
	    	%VId is in range format in clause(ether vid x-y)
	          sub_string(X,10,Len,_,Range),
	          isExprARange(Range),
	          Start is 10+Len,
	          sub_string(X,Start,1,_,' '),
	          sub_string(Range,0,Len2,_,LeftOfRange),%LeftOfRange is Left number in string Format
	          Start2 is 1+Len2,
	          not(sub_string(Range,Start2,1,_,'-')),
	          Start3 is Start2,
	          sub_string(Range,Start3,Len3,_,RightOfRange),%RightOfRange same as LeftOfRange
	          Start4 is 1+Len3,
	          sub_string(Range,Start4,_,0,_),
	          atom_number(LeftOfRange,LeftNum),
	          atom_number(RightOfRange,RightNum),
	          atom_number(VlanId,VlanIdNum),
	          LeftNum=<VlanIdNum,	%Check if VLAn id lies within range
	          RightNum>=VlanIdNum
	      )
	    )
        ;
            (   
                sub_string(X,_,_,_,'any')
            )
         ).
/*------------------SRC IP--------------------*/
	isSrcIPRejected(SrcIP) :- 
    	reject(X),
    	not(sub_string(SrcIP,_,_,_,"*")),
        atom_length(X,XLength),	%XLength stores length of X
    	sub_string(X,_,_,_,'ip'),
    	(   
        (
    		%src ip syntax:- ip src addr or src addr dst addr
          (
            sub_string(X,SrcIndex,3,_,'src'),
            Start1 is SrcIndex+9,
                (   
                 %src and dst addr(' ' signifies space before dst)
                  (
                    sub_string(X,Start2,_,_,"dst"),
                    Start2 > Start1,
                    Length is Start2-Start1-1,
                    sub_string(X,Start1,Length,_,SrcIPList),
                      (   
                      	(
                        	isExprARange(SrcIPList),
                            isIPInRange(SrcIP,SrcIPList)
                        )
                      	;
                      	(
                    		sub_string(SrcIPList,_,_,_,SrcIP)                        	
                        )
                      )

                  );
                 %only src addr present
                 (	
                     not(sub_string(X,_,3,_,'dst')),
                     sub_string(X,_,3,_,'src'),
                     (
                     (
                       StrLen is XLength - Start1
                     )
                     ;
                     (  
                      not(sub_string(X,_,3,_,'dst')),
                      sub_string(X,ProtoIndex,_,_,'proto'),
                      StrLen is ProtoIndex - Start1 -1
                     )
                     ),
                     sub_string(X,Start1,StrLen,_,SrcIPList),
                     (   
                      	(
                        	isExprARange(SrcIPList),
                            isIPInRange(SrcIP,SrcIPList)
                        )
                      	;
                      	(
                    		sub_string(SrcIPList,_,_,_,SrcIP)                        	
                        )
                      )
                 )
               )
          );
          %deals with the case when only addr is written
           (   
                not(sub_string(X,_,3,_,'dst')),
                not(sub_string(X,_,3,_,'src')),
                sub_string(X,Start,4,_,'addr'),
                Start2 is Start+5,
               	StrLen is XLength - Start2,
                sub_string(X,Start2,StrLen,_,SrcIPList),
               	(   
                      	(
                        	isExprARange(SrcIPList),
                            isIPInRange(SrcIP,SrcIPList)
                        )
                      	;
                      	(
                    		sub_string(SrcIPList,_,_,_,SrcIP)                        	
                        )
                      )
           )
        )
        ;
            (   
                sub_string(X,_,_,_,'any')
            )
       ).


    %------DST IP
	isDstIPRejected(DstIP) :- 
    	reject(X),
    	atom_length(X,XLength),
    	not(sub_string(DstIP,_,_,_,"*")),
    	sub_string(X,0,2,_,'ip'),
     (   
        (
    %dst ip syntax:- ip dst addr or src addr dst addr 
          (
            sub_string(X,_,3,_,'dst'),
                (   
                 %both src and dst addr present
                  (
                  	sub_string(X,SrcIndex,3,_,'src'),
            		Start1 is SrcIndex+9,
                    sub_string(X,Start2,_,_,"dst"),
                    Start2 >= Start1,
                     DstStart is Start2 + 9,
                    (
                      (   
                      	sub_string(X,ProtoIndex,_,_,'proto'),
                      	Length is ProtoIndex-DstStart+1
                      )
                      ;
                      (   
                        not(sub_string(X,_,_,_,'proto')),
                        Length is XLength - DstStart
                      )  
                    ),
                    sub_string(X,DstStart,Length,_,DstIPList),
                      (   
                      /*-------Checking if there is a range------*/
                      	(
                        	isExprARange(DstIPList),
                            isIPInRange(DstIP,DstIPList)
                        )
                      	;
                      /*-------Checking if there is a direct match(i.e. discrete or list)------*/
                      	(
                    		sub_string(DstIPList,_,_,_,DstIP)                        	
                        )
                      )

                  );
                /*-----------only dst addr present------------*/
                 (
                     not(sub_string(X,_,3,_,'src')),
                     sub_string(X,DstStartTemp,3,_,'dst'),
                     DstStart is DstStartTemp + 9,
                     StrLen is XLength - DstStart,
                     sub_string(X,DstStart,StrLen,_,DstIPList),
                     (   
                      	(
                        	isExprARange(DstIPList),
                            isIPInRange(DstIP,DstIPList)
                        )
                      	;
                      	(
                    		sub_string(DstIPList,_,_,_,DstIP)                        	
                        )
                      )
                 )
               )
          );
        /*--------deals with the case when only addr is written-------*/
           (   
                not(sub_string(X,_,3,_,'dst')),
                not(sub_string(X,_,3,_,'src')),
                sub_string(X,Start,4,_,'addr'),
                Start2 is Start+5,
               	StrLen is XLength - Start2,
                sub_string(X,Start2,StrLen,_,DstIPList),
               	(   
                      	(
                        	isExprARange(DstIPList),
                            isIPInRange(DstIP,DstIPList)
                        )
                      	;
                      	(
                    		sub_string(DstIPList,_,_,_,DstIP)                        	
                        )
                      )
           )
        );
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).

     
     %Checks if TCP Src is rejected
	isTCPSrcRejected(TCPPortNo) :- 
    	reject(X),
    	atom_length(X,XLength),
    	not(sub_string(TCPPortNo,_,_,_,"*")),
    	sub_string(X,_,3,_,'tcp'),
    	sub_string(X,Start,3,_,'src'),
    	(
        (   
    	ListStart is Start+9,
    	Length is XLength - ListStart,
    	sub_string(X,ListStart,Length,_,TCPList),
    		(   
    		 %Direct Match
              (   
              	sub_string(TCPList,_,_,_,TCPPortNo)
              );
    		 %TCP Port no is in list
              ( 
              	isExprARange(TCPList),
                atom_length(TCPList,ListLength),
                sub_string(TCPList,HyphenIndex,1,_,'-'),
                sub_string(TCPList,0,HyphenIndex,_,LeftOfRange),
                StartOfRight is HyphenIndex + 1,
                LengthOfRight is ListLength - StartOfRight,
                sub_string(TCPList,StartOfRight,LengthOfRight,_,RightOfRange),
                atom_number(LeftOfRange,LeftNum),
                atom_number(RightOfRange,RightNum),
                atom_number(TCPPortNo,TCPPortNum),
                LeftNum=<TCPPortNum,
                RightNum>=TCPPortNum
              )
            ));
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).
    		
	isTCPDstRejected(TCPPortNo) :- 
    	reject(X),
    	atom_length(X,XLength),
    	sub_string(X,_,3,_,'tcp'),
    	sub_string(X,Start,3,_,'dst'),
    	not(sub_string(TCPPortNo,_,_,_,"*")),
    (   
     (   
    	%Start of the list of port no is same and length depends upon whether src is present or not
    	ListStart is Start+9,
    	(   
          (
          	sub_string(X,SrcStart,3,_,'src'),
            Length is SrcStart - ListStart -1
          )
          ;
          (   
          	Length is XLength - ListStart
          )
        ),
    	sub_string(X,ListStart,Length,_,TCPList),
    		(   
              (   
              	sub_string(TCPList,_,_,_,TCPPortNo)
              );
              ( 
              	isExprARange(TCPList),
                atom_length(TCPList,ListLength),
                sub_string(TCPList,HyphenIndex,1,_,'-'),
                sub_string(TCPList,0,HyphenIndex,_,LeftOfRange),
                StartOfRight is HyphenIndex + 1,
                LengthOfRight is ListLength - StartOfRight,
                sub_string(TCPList,StartOfRight,LengthOfRight,_,RightOfRange),
                atom_number(LeftOfRange,LeftNum),
                atom_number(RightOfRange,RightNum),
                atom_number(TCPPortNo,TCPPortNum),
                LeftNum=<TCPPortNum,
                RightNum>=TCPPortNum
              )
            )
        )
       ;
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).
/*-----------------------UDP SRC and DST reject------------------*/
isUDPSrcRejected(UDPPortNo) :- 
    	reject(X),
    	atom_length(X,XLength),
    	not(sub_string(UDPPortNo,_,_,_,"*")),
    	sub_string(X,_,3,_,'udp'),
    	sub_string(X,Start,3,_,'src'),
    (   
     (   
    	ListStart is Start+9,
    	Length is XLength - ListStart,
    	sub_string(X,ListStart,Length,_,UDPList),
    		(   
              (   
              	sub_string(UDPList,_,_,_,UDPPortNo)
              );
              ( 
              	isExprARange(UDPList),
                atom_length(UDPList,ListLength),
                sub_string(UDPList,HyphenIndex,1,_,'-'),
                sub_string(UDPList,0,HyphenIndex,_,LeftOfRange),
                StartOfRight is HyphenIndex + 1,
                LengthOfRight is ListLength - StartOfRight,
                sub_string(UDPList,StartOfRight,LengthOfRight,_,RightOfRange),
                atom_number(LeftOfRange,LeftNum),
                atom_number(RightOfRange,RightNum),
                atom_number(UDPPortNo,UDPPortNum),
                LeftNum=<UDPPortNum,
                RightNum>=UDPPortNum
              )
            )
     )
    ;
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).
	isUDPDstRejected(UDPPortNo) :- 
    	reject(X),
    	atom_length(X,XLength),
    	not(sub_string(UDPPortNo,_,_,_,"*")),
    	sub_string(X,_,3,_,'udp'),
    	sub_string(X,Start,3,_,'dst'),
    (   
     (   
    	ListStart is Start+9,
    	(   
          (
          	sub_string(X,SrcStart,3,_,'src'),
            Length is SrcStart - ListStart -1
          )
          ;
          (   
          	Length is XLength - ListStart
          )
        ),
    	sub_string(X,ListStart,Length,_,UDPList),
    		(   
              (   
              	sub_string(UDPList,_,_,_,UDPPortNo)
              );
              ( 
              	isExprARange(UDPList),
                atom_length(UDPList,ListLength),
                sub_string(UDPList,HyphenIndex,1,_,'-'),
                sub_string(UDPList,0,HyphenIndex,_,LeftOfRange),
                StartOfRight is HyphenIndex + 1,
                LengthOfRight is ListLength - StartOfRight,
                sub_string(UDPList,StartOfRight,LengthOfRight,_,RightOfRange),
                atom_number(LeftOfRange,LeftNum),
                atom_number(RightOfRange,RightNum),
                atom_number(UDPPortNo,UDPPortNum),
                LeftNum=<UDPPortNum,
                RightNum>=UDPPortNum
              )
            )
     )
    ;
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).

isIPV6SrcRejected(IPV6SrcAddr) :- 
    reject(X),
    sub_string(X,_,4,_,'ipv6'),
    atom_length(X,XLength),
    not(sub_string(IPV6SrcAddr,_,_,_,"*")),
   (   
    (   
    (
    /*------------ipv6 src addr or ipv6 src addr dst addr--------------*/
    (
      sub_string(X,SrcStart,3,_,'src'),
      Start is SrcStart + 9,
      (
      	/*-----------ipv6 src addr dst addr---------------*/
      	(   
        	sub_string(X,DstStart,3,_,'dst'),
            Length is DstStart - SrcStart -1
        )
        ;
      	(   
        	/*-------------ipv6 src addr only----------------*/
        	not(sub_string(X,_,3,_,'dst')),
            not(sub_string(X,_,5,_,'proto')),
            Length is XLength - Start
        )
      	;
      	(   
        	/*-------------ipv6 src addr and proto----------------*/
        	not(sub_string(X,_,3,_,'dst')),
            sub_string(X,ProtoIndex,_,_,'proto'),
            Length is ProtoIndex - Start -1
        )
      ),
      sub_string(X,Start,Length,_,IPSrcList),
        (
        /*---------Direct Match (discrete atom or list of values)--------*/
          (   
          	sub_string(IPSrcList,_,_,_,IPV6SrcAddr)
          )
          /*;*/
        /*---------Range of Values------------*/
          /*( 
          
          )*/
        )
    )
     ;
    /*----------ipv6 addr----------*/
    (   
    	sub_string(X,AddrLocn,_,_,'addr'),
        not(sub_string(X,_,_,_,'src')),
        not(sub_string(X,_,_,_,'dst')),
        Start is AddrLocn + 5,
        Length is XLength - Start,
     	sub_string(X,Start,Length,_,IPSrcList),
        (
        /*---------Direct Match (discrete atom or list of values)--------*/
          (   
          	sub_string(IPSrcList,_,_,_,IPV6SrcAddr)
          )
          /*;*/
        /*---------Range of Values------------*/
          /*( 
          
          )*/
        )
    )
    )
    )
   ;
    	(   
        	sub_string(X,_,_,_,'any')
        )
    ).
    
isIPV6DstRejected(IPV6DstAddr) :- 
    reject(X),
    sub_string(X,_,4,_,'ipv6'),
    atom_length(X,XLength),
    not(sub_string(IPV6DstAddr,_,_,_,"*")),
    (   
    (   
    (
    /*------------ipv6 dst addr or ipv6 src addr dst addr--------------*/
    (
      sub_string(X,DstStart,3,_,'dst'),
      Start is DstStart + 9,
      (
      	/*-----------ipv6 src addr dst addr or---------------*/
        	/*-------------ipv6 dst addr only, length remains same----------------*/
            (
            	not(sub_string(X,_,_,_,'proto')),
            	Length is XLength - Start
            )
      		;
      		(   
            	sub_string(X,ProtoIndex,_,_,'proto'),
                Length is ProtoIndex-DstStart-1
            )
      ),
      sub_string(X,Start,Length,_,IPDstList),
        (
        /*---------Direct Match (discrete atom or list of values)--------*/
          (   
          	sub_string(IPDstList,_,_,_,IPV6DstAddr)
          )
          /*;*/
        /*---------Range of Values------------*/
          /*( 
          
          )*/
        )
    )
     ;
    /*----------ipv6 addr----------*/
    (   
    	sub_string(X,AddrLocn,_,_,'addr'),
        not(sub_string(X,_,_,_,'src')),
        not(sub_string(X,_,_,_,'dst')),
        Start is AddrLocn + 5,
        Length is XLength - Start,
     	sub_string(X,Start,Length,_,IPDstList),
        (
        /*---------Direct Match (discrete atom or list of values)--------*/
          (   
          	sub_string(IPDstList,_,_,_,IPV6DstAddr)
          )
          /*;*/
        /*---------Range of Values------------*/
          /*( 
          
          )*/
        )
    )
    )
    )
    ;
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).
isICMPTypeRejected(Type) :- 
    reject(X),
    atom_length(X,XLength),
    sub_string(X,_,_,_,'icmp'),
    not(sub_string(X,_,_,_,'icmpv6')),
    sub_string(X,StartTemp,_,_,'type'),
    not(sub_string(Type,_,_,_,"*")),
    (   
    (   
    Start is StartTemp + 5,
    (
    	(
        	sub_string(X,CodeStart,_,_,'code'),
            Length is CodeStart - Start - 1
        )
    	;   
    	(   
        	not(sub_string(X,_,_,_,'code')),
            Length is XLength - Start
        )
    ),
    sub_string(X,Start,Length,_,Type)
    );
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).
    
isICMPCodeRejected(Code) :- 
    reject(X),
    atom_length(X,XLength),
    sub_string(X,_,_,_,'icmp'),
    not(sub_string(X,_,_,_,'icmpv6')),
    sub_string(X,StartTemp,_,_,'code'),
    not(sub_string(Code,_,_,_,"*")),
    (   
    (   
    Start is StartTemp + 5,
    (
            Length is XLength - Start
    ),
    sub_string(X,Start,Length,_,Code)
    );
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).
/*----------------ICMPV6 type and code rejected------------------*/
isICMPV6TypeRejected(Type) :- 
    reject(X),
    atom_length(X,XLength),
    sub_string(X,_,_,_,'icmpv6'),
    sub_string(X,StartTemp,_,_,'type'),
    not(sub_string(Type,_,_,_,"*")),
    (   
    (   
    Start is StartTemp + 5,
    (
    	(
        	sub_string(X,CodeStart,_,_,'code'),
            Length is CodeStart - Start - 1
        )
    	;   
    	(   
        	not(sub_string(X,_,_,_,'code')),
            Length is XLength - Start
        )
    ),
    sub_string(X,Start,Length,_,Type)
    );
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).
    
isICMPV6CodeRejected(Code) :- 
    reject(X),
    atom_length(X,XLength),
    sub_string(X,_,_,_,'icmpv6'),
    sub_string(X,StartTemp,_,_,'code'),
    not(sub_string(Code,_,_,_,"*")),
    (   
    (   
    Start is StartTemp + 5,
    (
            Length is XLength - Start
    ),
    sub_string(X,Start,Length,_,Code)
    );
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).


/*----------------FACTS-------------*/

/*	RULE BASE SYNTAX
 * isAdapterDropped(AdapterName) 
 * isProtocolIDDropped(ProtocolId)
 * isVlanIDDropped(VlanId)
 * isSrcIPDropped(SrcIP) 
 * isDstIPDropped(DstIP)
 * isTCPSrcDropped(TCPPortNo)
 * isTCPDstDropped(TCPPortNo)
 * isUDPSrcDropped(UDPPortNo)
 * isUDPDstDropped(UDPPortNo)
 * isIPV6SrcDropped(IPV6SrcAddr)    
 * isIPV6DstDropped(IPV6DstAddr)
 * isICMPTypeDropped(Type)
 * isICMPCodeDropped(Code)
 * isICMPV6TypeDropped(Type)
 * isICMPV6CodeDropped(Code)
 * */
/*------------Rule to see if adapter is dropable------------*/
isAdapterDropped(AdapterName) :- 
    drop(X),	%Check for clauses in drop predicate
    sub_string(X,_,_,_,'adapter'),	%Check if adapter is present in clause	
    not(sub_string(AdapterName,_,_,_,"*")),
    (
    	%There's a direct match
	    (
		     sub_string(X,_,_,_,AdapterNamePresent),
		     AdapterNamePresent=AdapterName
	    )
	    ;
    	%Adapter present between given range
	    (
		     isExprARange(X),
		     sub_string(X,8,1,_,LeftOfRange),
		     sub_string(X,10,1,_,RightOfRange),
		     char_code(LeftOfRange,LeftOfRangeAscii),
		     char_code(RightOfRange,RightOfRangeAscii),
		     char_code(AdapterName,AdapterAscii),
		     AdapterAscii>=LeftOfRangeAscii,
		     AdapterAscii=<RightOfRangeAscii
	    )
	    ;
    	%if any is present drop all adapters
	    (   
	    	 sub_string(X,8,3,_,'any')
	    )
    ).

    /*------------Rule to see if ProtocolID is dropable------------*/
	isProtocolIDDropped(ProtocolId) :- 
	    drop(X),
    	sub_string(X,_,_,_,'ether'),
    	sub_string(X,_,_,_,'proto'),
    	not(sub_string(ProtocolId,_,_,_,"*")),
	 (   
        (
	      (
	        sub_string(X,_,_,_,'ether proto'),	
	        % no vlan id present in clause (ether proto and no vid)
	        sub_string(X,_,_,_,PresentProtocolID),
	        sub_string(PresentProtocolID,_,_,_,ProtocolId)
	      )
	    	;
	      % vlan id present in clause (ether vid _ proto )
	      (   
	          sub_string(X,_,_,_,'proto'),
		 sub_string(X,_,_,_,'vid'),
	          %Direct match now
	          sub_string(X,_,_,_,PresentProtocolID),
	          sub_string(PresentProtocolID,_,_,_,ProtocolId)
	      )
	    )
    	;
    	(   
        	sub_string(X,_,_,_,'any')
        )
     )
    	.

/*------------Rule to see if VlanID is dropable------------*/
	isVlanIDDropped(VlanId) :- 
	    drop(X),   
         sub_string(X,_,_,_,'ether vid'),
         not(sub_string(VlanId,_,_,_,"*")),
      (   
	    (   
	    		%direct match
	      (
	          sub_string(X,Start,_,_,PresentVlanID),
	          sub_string(X,ProtoIndex,5,_,'proto'),
	          Start<ProtoIndex,
	          PresentVlanID = VlanId
	      )
	      ;
	      (
	    	%VId is in range format in clause(ether vid x-y)
	          sub_string(X,10,Len,_,Range),
	          isExprARange(Range),
	          Start is 10+Len,
	          sub_string(X,Start,1,_,' '),
	          sub_string(Range,0,Len2,_,LeftOfRange),%LeftOfRange is Left number in string Format
	          Start2 is 1+Len2,
	          not(sub_string(Range,Start2,1,_,'-')),
	          Start3 is Start2,
	          sub_string(Range,Start3,Len3,_,RightOfRange),%RightOfRange same as LeftOfRange
	          Start4 is 1+Len3,
	          sub_string(Range,Start4,_,0,_),
	          atom_number(LeftOfRange,LeftNum),
	          atom_number(RightOfRange,RightNum),
	          atom_number(VlanId,VlanIdNum),
	          LeftNum=<VlanIdNum,	%Check if VLAn id lies within range
	          RightNum>=VlanIdNum
	      )
	    )
        ;
            (   
                sub_string(X,_,_,_,'any')
            )
         ).
/*------------------SRC IP--------------------*/
	isSrcIPDropped(SrcIP) :- 
    	drop(X),
        atom_length(X,XLength),	%XLength stores length of X
    	sub_string(X,0,2,_,'ip'),
    	not(sub_string(SrcIP,_,_,_,"*")),
    	(   
        (
    		%src ip syntax:- ip src addr or src addr dst addr
          (
            sub_string(X,SrcIndex,3,_,'src'),
            Start1 is SrcIndex+9,
                (   
                 %src and dst addr(' ' signifies space before dst)
                  (
                    sub_string(X,Start2,_,_,"dst"),
                    Start2 >= Start1,
                    Length is Start2-Start1-1,
                    sub_string(X,Start1,Length,_,SrcIPList),
                      (   
                      	(
                        	isExprARange(SrcIPList),
                            isIPInRange(SrcIP,SrcIPList)
                        )
                      	;
                      	(
                    		sub_string(SrcIPList,_,_,_,SrcIP)                        	
                        )
                      )

                  );
                 %only src addr present
                 (	
                     not(sub_string(X,_,3,_,'dst')),
                     sub_string(X,_,3,_,'src'),
                     (
                     (
                       StrLen is XLength - Start1
                     )
                     ;
                     (  
                      not(sub_string(X,_,3,_,'dst')),
                      sub_string(X,ProtoIndex,_,_,'proto'),
                      StrLen is ProtoIndex - Start1 -1
                     )
                     ),
                     sub_string(X,Start1,StrLen,_,SrcIPList),
                     (   
                      	(
                        	isExprARange(SrcIPList),
                            isIPInRange(SrcIP,SrcIPList)
                        )
                      	;
                      	(
                    		sub_string(SrcIPList,_,_,_,SrcIP)                        	
                        )
                      )
                 )
               )
          );
          %deals with the case when only addr is written
           (   
                not(sub_string(X,_,3,_,'dst')),
                not(sub_string(X,_,3,_,'src')),
                sub_string(X,Start,4,_,'addr'),
                Start2 is Start+5,
               	StrLen is XLength - Start2,
                sub_string(X,Start2,StrLen,_,SrcIPList),
               	(   
                      	(
                        	isExprARange(SrcIPList),
                            isIPInRange(SrcIP,SrcIPList)
                        )
                      	;
                      	(
                    		sub_string(SrcIPList,_,_,_,SrcIP)                        	
                        )
                      )
           )
        )
        ;
            (   
                sub_string(X,_,_,_,'any')
            )
       ).


    %------DST IP
	isDstIPDropped(DstIP) :- 
    	drop(X),
    	not(sub_string(DstIP,_,_,_,"*")),
    	atom_length(X,XLength),
    	sub_string(DstIP,0,2,_,'ip'),
     (   
        (
    %dst ip syntax:- ip dst addr or src addr dst addr 
          (
            sub_string(X,_,3,_,'dst'),
                (   
                 %both src and dst addr present
                  (
                  	sub_string(X,SrcIndex,3,_,'src'),
            		Start1 is SrcIndex+9,
                    sub_string(X,Start2,1,_,' '),
                    Start2 >= Start1,
                     DstStart is Start2 + 10,
                    (
                      (   
                      	sub_string(X,ProtoIndex,_,_,'proto'),
                      	Length is ProtoIndex-DstStart+1
                      )
                      ;
                      (   
                        not(sub_string(X,_,_,_,'proto')),
                        Length is XLength - DstStart
                      )  
                    ),
                    sub_string(X,DstStart,Length,_,DstIPList),
                      (   
                      /*-------Checking if there is a range------*/
                      	(
                        	isExprARange(DstIPList),
                            isIPInRange(DstIP,DstIPList)
                        )
                      	;
                      /*-------Checking if there is a direct match(i.e. discrete or list)------*/
                      	(
                    		sub_string(DstIPList,_,_,_,DstIP)                        	
                        )
                      )

                  );
                /*-----------only dst addr present------------*/
                 (
                     not(sub_string(X,_,3,_,'src')),
                     sub_string(X,DstStartTemp,3,_,'dst'),
                     DstStart is DstStartTemp + 9,
                     StrLen is XLength - DstStart,
                     sub_string(X,DstStart,StrLen,_,DstIPList),
                     (   
                      	(
                        	isExprARange(DstIPList),
                            isIPInRange(DstIP,DstIPList)
                        )
                      	;
                      	(
                    		sub_string(DstIPList,_,_,_,DstIP)                        	
                        )
                      )
                 )
               )
          );
        /*--------deals with the case when only addr is written-------*/
           (   
                not(sub_string(X,_,3,_,'dst')),
                not(sub_string(X,_,3,_,'src')),
                sub_string(X,Start,4,_,'addr'),
                Start2 is Start+5,
               	StrLen is XLength - Start2,
                sub_string(X,Start2,StrLen,_,DstIPList),
               	(   
                      	(
                        	isExprARange(DstIPList),
                            isIPInRange(DstIP,DstIPList)
                        )
                      	;
                      	(
                    		sub_string(DstIPList,_,_,_,DstIP)                        	
                        )
                      )
           )
        );
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).

     %Checks if TCP Src is droped
	isTCPSrcDropped(TCPPortNo) :- 
    	drop(X),
    	atom_length(X,XLength),
    	not(sub_string(TCPPortNo,_,_,_,"*")),
    	sub_string(X,_,3,_,'tcp'),
    	sub_string(X,Start,3,_,'src'),
    	(
        (   
    	ListStart is Start+9,
    	Length is XLength - ListStart,
    	sub_string(X,ListStart,Length,_,TCPList),
    		(   
    		 %Direct Match
              (   
              	sub_string(TCPList,_,_,_,TCPPortNo)
              );
    		 %TCP Port no is in list
              ( 
              	isExprARange(TCPList),
                atom_length(TCPList,ListLength),
                sub_string(TCPList,HyphenIndex,1,_,'-'),
                sub_string(TCPList,0,HyphenIndex,_,LeftOfRange),
                StartOfRight is HyphenIndex + 1,
                LengthOfRight is ListLength - StartOfRight,
                sub_string(TCPList,StartOfRight,LengthOfRight,_,RightOfRange),
                atom_number(LeftOfRange,LeftNum),
                atom_number(RightOfRange,RightNum),
                atom_number(TCPPortNo,TCPPortNum),
                LeftNum=<TCPPortNum,
                RightNum>=TCPPortNum
              )
            ));
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).
    		
	isTCPDstDropped(TCPPortNo) :- 
    	drop(X),
    	atom_length(X,XLength),
    	not(sub_string(TCPPortNo,_,_,_,"*")),
    	sub_string(X,_,3,_,'tcp'),
    	sub_string(X,Start,3,_,'dst'),
    (   
     (   
    	%Start of the list of port no is same and length depends upon whether src is present or not
    	ListStart is Start+9,
    	(   
          (
          	sub_string(X,SrcStart,3,_,'src'),
            Length is SrcStart - ListStart -1
          )
          ;
          (   
          	Length is XLength - ListStart
          )
        ),
    	sub_string(X,ListStart,Length,_,TCPList),
    		(   
              (   
              	sub_string(TCPList,_,_,_,TCPPortNo)
              );
              ( 
              	isExprARange(TCPList),
                atom_length(TCPList,ListLength),
                sub_string(TCPList,HyphenIndex,1,_,'-'),
                sub_string(TCPList,0,HyphenIndex,_,LeftOfRange),
                StartOfRight is HyphenIndex + 1,
                LengthOfRight is ListLength - StartOfRight,
                sub_string(TCPList,StartOfRight,LengthOfRight,_,RightOfRange),
                atom_number(LeftOfRange,LeftNum),
                atom_number(RightOfRange,RightNum),
                atom_number(TCPPortNo,TCPPortNum),
                LeftNum=<TCPPortNum,
                RightNum>=TCPPortNum
              )
            )
        )
       ;
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).
/*-----------------------UDP SRC and DST drop------------------*/
isUDPSrcDropped(UDPPortNo) :- 
    	drop(X),
    	atom_length(X,XLength),
    	not(sub_string(UDPPortNo,_,_,_,"*")),
    	sub_string(X,_,3,_,'udp'),
    	sub_string(X,Start,3,_,'src'),
    (   
     (   
    	ListStart is Start+9,
    	Length is XLength - ListStart,
    	sub_string(X,ListStart,Length,_,UDPList),
    		(   
              (   
              	sub_string(UDPList,_,_,_,UDPPortNo)
              );
              ( 
              	isExprARange(UDPList),
                atom_length(UDPList,ListLength),
                sub_string(UDPList,HyphenIndex,1,_,'-'),
                sub_string(UDPList,0,HyphenIndex,_,LeftOfRange),
                StartOfRight is HyphenIndex + 1,
                LengthOfRight is ListLength - StartOfRight,
                sub_string(UDPList,StartOfRight,LengthOfRight,_,RightOfRange),
                atom_number(LeftOfRange,LeftNum),
                atom_number(RightOfRange,RightNum),
                atom_number(UDPPortNo,UDPPortNum),
                LeftNum=<UDPPortNum,
                RightNum>=UDPPortNum
              )
            )
     )
    ;
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).
	isUDPDstDropped(UDPPortNo) :- 
    	drop(X),
    	atom_length(X,XLength),
    	not(sub_string(UDPPortNo,_,_,_,"*")),
    	sub_string(X,_,3,_,'udp'),
    	sub_string(X,Start,3,_,'dst'),
    (   
     (   
    	ListStart is Start+9,
    	(   
          (
          	sub_string(X,SrcStart,3,_,'src'),
            Length is SrcStart - ListStart -1
          )
          ;
          (   
          	Length is XLength - ListStart
          )
        ),
    	sub_string(X,ListStart,Length,_,UDPList),
    		(   
              (   
              	sub_string(UDPList,_,_,_,UDPPortNo)
              );
              ( 
              	isExprARange(UDPList),
                atom_length(UDPList,ListLength),
                sub_string(UDPList,HyphenIndex,1,_,'-'),
                sub_string(UDPList,0,HyphenIndex,_,LeftOfRange),
                StartOfRight is HyphenIndex + 1,
                LengthOfRight is ListLength - StartOfRight,
                sub_string(UDPList,StartOfRight,LengthOfRight,_,RightOfRange),
                atom_number(LeftOfRange,LeftNum),
                atom_number(RightOfRange,RightNum),
                atom_number(UDPPortNo,UDPPortNum),
                LeftNum=<UDPPortNum,
                RightNum>=UDPPortNum
              )
            )
     )
    ;
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).

isIPV6SrcDropped(IPV6SrcAddr) :- 
    drop(X),
    sub_string(X,_,4,_,'ipv6'),
    not(sub_string(IPV6SrcAddr,_,_,_,"*")),
    atom_length(X,XLength),
   (   
    (   
    (
    /*------------ipv6 src addr or ipv6 src addr dst addr--------------*/
    (
      sub_string(X,SrcStart,3,_,'src'),
      Start is SrcStart + 9,
      (
      	/*-----------ipv6 src addr dst addr---------------*/
      	(   
        	sub_string(X,DstStart,3,_,'dst'),
            Length is DstStart - SrcStart -1
        )
        ;
      	(   
        	/*-------------ipv6 src addr only----------------*/
        	not(sub_string(X,_,3,_,'dst')),
            not(sub_string(X,_,5,_,'proto')),
            Length is XLength - Start
        )
      	;
      	(   
        	/*-------------ipv6 src addr and proto----------------*/
        	not(sub_string(X,_,3,_,'dst')),
            sub_string(X,ProtoIndex,_,_,'proto'),
            Length is ProtoIndex - Start -1
        )
      ),
      sub_string(X,Start,Length,_,IPSrcList),
        (
        /*---------Direct Match (discrete atom or list of values)--------*/
          (   
          	sub_string(IPSrcList,_,_,_,IPV6SrcAddr)
          )
          /*;*/
        /*---------Range of Values------------*/
          /*( 
          
          )*/
        )
    )
     ;
    /*----------ipv6 addr----------*/
    (   
    	sub_string(X,AddrLocn,_,_,'addr'),
        not(sub_string(X,_,_,_,'src')),
        not(sub_string(X,_,_,_,'dst')),
        Start is AddrLocn + 5,
        Length is XLength - Start,
     	sub_string(X,Start,Length,_,IPSrcList),
        (
        /*---------Direct Match (discrete atom or list of values)--------*/
          (   
          	sub_string(IPSrcList,_,_,_,IPV6SrcAddr)
          )
          /*;*/
        /*---------Range of Values------------*/
          /*( 
          
          )*/
        )
    )
    )
    )
   ;
    	(   
        	sub_string(X,_,_,_,'any')
        )
    ).
    
isIPV6DstDropped(IPV6DstAddr) :- 
    drop(X),
    sub_string(X,_,4,_,'ipv6'),
    not(sub_string(IPV6DstAddr,_,_,_,"*")),
    atom_length(X,XLength),
    (   
    (   
    (
    /*------------ipv6 dst addr or ipv6 src addr dst addr--------------*/
    (
      sub_string(X,_,3,_,'src'),
      sub_string(X,DstStart,3,_,'dst'),
      Start is DstStart + 9,
      (
      	/*-----------ipv6 src addr dst addr or---------------*/
        	/*-------------ipv6 src addr only, length remains same----------------*/
            (
            	not(sub_string(X,_,_,_,'proto')),
            	Length is XLength - Start
            )
      		;
      		(   
            	sub_string(X,ProtoIndex,_,_,'proto'),
                Length is ProtoIndex-DstStart+1
            )
      ),
      sub_string(X,Start,Length,_,IPDstList),
        (
        /*---------Direct Match (discrete atom or list of values)--------*/
          (   
          	sub_string(IPDstList,_,_,_,IPV6DstAddr)
          )
          /*;*/
        /*---------Range of Values------------*/
          /*( 
          
          )*/
        )
    )
     ;
    /*----------ipv6 addr----------*/
    (   
    	sub_string(X,AddrLocn,_,_,'addr'),
        not(sub_string(X,_,_,_,'src')),
        not(sub_string(X,_,_,_,'dst')),
        Start is AddrLocn + 5,
        Length is XLength - Start,
     	sub_string(X,Start,Length,_,IPDstList),
        (
        /*---------Direct Match (discrete atom or list of values)--------*/
          (   
          	sub_string(IPDstList,_,_,_,IPV6DstAddr)
          )
          /*;*/
        /*---------Range of Values------------*/
          /*( 
          
          )*/
        )
    )
    )
    )
    ;
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).
isICMPTypeDropped(Type) :- 
    drop(X),
    atom_length(X,XLength),
    sub_string(X,_,_,_,'icmp'),
    not(sub_string(X,_,_,_,'icmpv6')),
    sub_string(X,StartTemp,_,_,'type'),
    not(sub_string(Type,_,_,_,"*")),
    (   
    (   
    Start is StartTemp + 5,
    (
    	(
        	sub_string(X,CodeStart,_,_,'code'),
            Length is CodeStart - Start - 1
        )
    	;   
    	(   
        	not(sub_string(X,_,_,_,'code')),
            Length is XLength - Start
        )
    ),
    sub_string(X,Start,Length,_,Type)
    );
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).
    
isICMPCodeDropped(Code) :- 
    drop(X),
    atom_length(X,XLength),
    sub_string(X,_,_,_,'icmp'),
    not(sub_string(Code,_,_,_,"*")),
    not(sub_string(X,_,_,_,'icmpv6')),
    sub_string(X,StartTemp,_,_,'code'),
    (   
    (   
    Start is StartTemp + 5,
    (
            Length is XLength - Start
    ),
    sub_string(X,Start,Length,_,Code)
    );
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).
/*----------------ICMPV6 type and code droped------------------*/
isICMPV6TypeDropped(Type) :- 
    drop(X),
    atom_length(X,XLength),
    not(sub_string(Type,_,_,_,"*")),
    sub_string(X,_,_,_,'icmpv6'),
    sub_string(X,StartTemp,_,_,'type'),
    (   
    (   
    Start is StartTemp + 5,
    (
    	(
        	sub_string(X,CodeStart,_,_,'code'),
            Length is CodeStart - Start - 1
        )
    	;   
    	(   
        	not(sub_string(X,_,_,_,'code')),
            Length is XLength - Start
        )
    ),
    sub_string(X,Start,Length,_,Type)
    );
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).
    
isICMPV6CodeDropped(Code) :- 
    drop(X),
    atom_length(X,XLength),
    not(sub_string(Code,_,_,_,"*")),
    sub_string(X,_,_,_,'icmpv6'),
    sub_string(X,StartTemp,_,_,'code'),
    (   
    (   
    Start is StartTemp + 5,
    (
            Length is XLength - Start
    ),
    sub_string(X,Start,Length,_,Code)
    );
    	(   
        	sub_string(X,_,_,_,'any')
        )
     ).