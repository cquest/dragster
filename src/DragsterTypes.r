#ifndef __DRAGSTERTYPES.R__
#define __DRAGSTERTYPES.R__

type 'PARA' {							/* paramêtres des tokens */
		array ParaArray {
			integer;						/* params */
		};
};

type 'TSKP' {				/* paramêtres tâches supplementaires  */
		integer;			/* queue number 	*/
		integer;			/* initial priority */
		integer;			/* code TSKC number */
		integer;			/* nombre de taches de ce type */
		longint;			/* globals size		*/
		longint;			/* locals size		*/
		longint;			/* stack size		*/
		integer;			/* needs RW Buffer	*/
		integer;			/* needs DB Buffer	*/
};

#endif __DRAGSTERTYPES.R__