- -   t e s t   f o r k   a n d   p u l   r e q u e s t �� 
 U S E   [ P R A X I S ]  
 G O  
 / * * * * * *   O b j e c t :     U s e r D e f i n e d F u n c t i o n   [ d b o ] . [ G e t D b a s ]         S c r i p t   D a t e :   1 0 / 8 / 2 0 1 5   8 : 5 8 : 2 9   A M   * * * * * * /  
 S E T   A N S I _ N U L L S   O N  
 G O  
 S E T   Q U O T E D _ I D E N T I F I E R   O N  
 G O  
  
 A L T E R   F u n c t i o n   [ d b o ] . [ G e t D b a s ]  
 (  
 	 @ B u s i n e s s I D   i n t  
 )  
 R e t u r n s   n v a r c h a r ( M A X )  
 A s  
 B e g i n  
 	 D e c l a r e   @ R e t u r n V a l u e   A s   n v a r c h a r ( M A X )  
  
 	 S e l e c t    
 	 	 @ R e t u r n V a l u e   =   S u b s t r i n g ( B u s i n e s s D B A s ,   0 ,   L e n ( B u s i n e s s D B A s ) )   - -   R e m o v e   t h e   t r a i l i n g   c o m m a  
 	 F r o m    
 	 (  
 	 	 S e l e c t  
 	 	 	 (  
 	 	 	 	 S e l e c t    
 	 	 	 	 	 L T R I M ( R T R I M ( d b a . N a m e ) )   +   ' ;   '  
 	 	 	 	 F r o m   B e l l e v u e . B u s i n e s s   b  
 	 	 	 	 	 I n n e r   J o i n   B e l l e v u e . D B A   d b a   O n   b . B u s i n e s s I D   =   d b a . B u s i n e s s I D   A n d   d b a . A c t i v e   =   1  
 	 	 	 	 W h e r e   b . B u s i n e s s I d   =   b 1 . B u s i n e s s I d  
 	 	 	 	 G r o u p   B y   d b a . N a m e  
 	 	 	 	 F o r   X m l   P a t h ( ' ' )  
 	 	 	 )   A s   B u s i n e s s D B A s  
 	 	 F r o m   B e l l e v u e . B u s i n e s s   b 1  
 	 	 W h e r e   b 1 . B u s i n e s s I d   =   @ B u s i n e s s I D  
 	 	 G r o u p   B y   b 1 . B u s i n e s s I d ,   b 1 . N a m e  
 	 )   A s   B u s i n e s s  
 	  
 	 R e t u r n   @ R e t u r n V a l u e  
 E n d  
  
 