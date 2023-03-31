**&---------------------------------------------------------------------*
**& Report ZGCO_INTERNALT_1
**&---------------------------------------------------------------------*
**&
**&---------------------------------------------------------------------*
REPORT zgco_internalt_1.

****************************************  EXAMPLE 1 **********************************************
* WORKING WITH INTERNAL TABLES, APPEND INSERT, MODIFY AND DELETE

START-OF-SELECTION.

*  PERFORM example_1.

*  PERFORM example_2.

*  PERFORM example_3.

* PERFORM example_4.

*  PERFORM example_5.

*  PERFORM example_6.

*  PERFORM example_7.

*  PERFORM example_8.

  PERFORM example_9.

*&---------------------------------------------------------------------*
*& Form example_1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM example_1 .

* Create modele, create structure for internal table
* the name of the table table, SFLIGHT
* CARRID, Désignation de la compagnie aérienne, Airline designation, hava yolu tanimi
* CONNID, Code liaison aérienne individuelle, Individual air link code
* PRICE,
* FLDATE, Date du vol

* Declare model, structure for internal table

  TYPES : BEGIN OF ty_sflight,
            carrid TYPE sflight-carrid,
            connid TYPE sflight-connid,
            price  TYPE sflight-price,
            fldate TYPE sflight-fldate,
          END OF ty_sflight.

* Declare internal table and structure

  DATA : ls_sflight TYPE ty_sflight,
         lt_sflight TYPE TABLE OF ty_sflight.

* Select some data from SFLIGHT table

  SELECT carrid, connid, price, fldate
  FROM sflight
  ORDER BY price
  INTO TABLE @lt_sflight.

* Use class cl_demo_output to write all table

  cl_demo_output=>display( lt_sflight ).

* read second entery of internal table
* read a single record from the internal table into the structure using index access

  READ TABLE lt_sflight INTO ls_sflight INDEX 20.

  cl_demo_output=>display( ls_sflight ).

* Read internal table record using key access.

  READ TABLE lt_sflight INTO ls_sflight WITH  KEY carrid ='AZ'.

  cl_demo_output=>display( ls_sflight ).

  READ TABLE lt_sflight INTO ls_sflight WITH  KEY price ='185'.

  cl_demo_output=>display( ls_sflight ).


ENDFORM.

*&---------------------------------------------------------------------*
*& Form example_2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*

* In this example we will use LOOP
* read whole banch of data from internal table
* create another internal table, lt_sflight2
* in this loop I want to append or write work area of every record to new internal table
* our internal table is it_sflight
* we loop at our internal table it_sflight every record written in this work area
* and this work area is appended to our second internal table

FORM example_2 .
  TYPES : BEGIN OF ty_sflight,
            carrid TYPE sflight-carrid,
            connid TYPE sflight-connid,
            price  TYPE sflight-price,
            fldate TYPE sflight-fldate,
          END OF ty_sflight.

* Declare internal table and structure

  DATA : ls_sflight  TYPE ty_sflight,
         lt_sflight  TYPE TABLE OF ty_sflight,
         lt_sflight2 TYPE TABLE OF ty_sflight.

* Select some data from SFLIGHT table

  SELECT carrid, connid, price, fldate
  FROM sflight
  INTO TABLE @lt_sflight.

  cl_demo_output=>display( lt_sflight ).

  LOOP AT  lt_sflight INTO ls_sflight.
    APPEND ls_sflight TO lt_sflight2.
  ENDLOOP.

  cl_demo_output=>display( lt_sflight2 ).

**************************************************************************************************************************************************
* Now, I want to fill the field price with the value 3250, first we have to clear second table.
* because we filled in before with a loop.

  CLEAR lt_sflight2.

  LOOP AT lt_sflight INTO ls_sflight.
    ls_sflight-price = 325.
    APPEND ls_sflight TO lt_sflight2.
  ENDLOOP.

  cl_demo_output=>display( lt_sflight2 ).

*****************************************************************************************************************************************************
* Now I want to set some restrictions in our loop, first we clear our second table
* I will display all carrid LH and I will set price 1005 in the work area.

  CLEAR lt_sflight2.

  LOOP AT lt_sflight INTO ls_sflight WHERE carrid = 'AZ'.
    ls_sflight-price = 1005.
    APPEND ls_sflight TO lt_sflight2.

  ENDLOOP.

  cl_demo_output=>display( lt_sflight2 ).

*****************************************************************************************************************************************************

* First I will put some restriction

  CLEAR lt_sflight2.

  LOOP AT lt_sflight INTO ls_sflight WHERE carrid = 'LH'.
    ls_sflight-price = 785.
    APPEND ls_sflight TO lt_sflight2.
  ENDLOOP.
  SORT lt_sflight2 BY fldate DESCENDING.

  cl_demo_output=>display( lt_sflight2 ).


*****************************************************************************************************************************************************
* Now I want a specific index between 12-20, I want to fill these fields with carrid ='AA' price='701'
* HERE ORDER BY is not used. ORDER BY is used just for select
* But you can use SORT BY after loop

  CLEAR lt_sflight2.

  LOOP AT lt_sflight INTO ls_sflight FROM 4 TO 10.
    ls_sflight-price = 123.
    APPEND ls_sflight TO lt_sflight2.
  ENDLOOP.
  SORT lt_sflight2  BY fldate ASCENDING.
  cl_demo_output=>display( lt_sflight2 ).

*****************************************************************************************************************************************************

ENDFORM.
*&---------------------------------------------------------------------*
*& Form example_3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM example_3 .

* In this example I will add (append) a new row at the end of the first internal table
* By using APPEND TO, you can add a row at the end of the table, by using INSERT, you can add at a specific index

* create model, structure
  TYPES : BEGIN OF ty_sflight,
            carrid TYPE sflight-carrid,
            connid TYPE sflight-connid,
            price  TYPE sflight-price,
            fldate TYPE sflight-fldate,
          END OF ty_sflight.

* Declare internal table and structure
  DATA : ls_sflight  TYPE ty_sflight,
         lt_sflight  TYPE TABLE OF ty_sflight,
         lt_sflight2 TYPE TABLE OF ty_sflight.

* First select all the concerning fields
  SELECT carrid, connid, price, fldate
  FROM sflight
  ORDER BY price
  INTO TABLE @lt_sflight.



* Now append structure to the table, here data types are very important
  ls_sflight-carrid = 'GC'. "CHAR3
  ls_sflight-connid = 1509. "NUMC4
  ls_sflight-price = 1984.
  ls_sflight-fldate = '19840915'. "AAAAMMJJ

  APPEND ls_sflight TO lt_sflight.

  cl_demo_output=>display( lt_sflight ).

***********************************************************************************************************
* This time I will use INSERT to insert a row at a specific index

  ls_sflight-carrid = 'OC'.
  ls_sflight-connid = 1982.
  ls_sflight-price = 1210.
  ls_sflight-fldate = '19811012'.

  INSERT ls_sflight INTO lt_sflight INDEX 2.

  cl_demo_output=>display( lt_sflight ).


ENDFORM.

*&---------------------------------------------------------------------*
*& Form example_4
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM example_4 .

*Now we will use modify method to modify the price

* create model, structure
  TYPES : BEGIN OF ty_sflight,
            carrid TYPE sflight-carrid,
            connid TYPE sflight-connid,
            price  TYPE sflight-price,
            fldate TYPE sflight-fldate,
          END OF ty_sflight.

* Declare internal table and structure
  DATA : ls_sflight  TYPE ty_sflight,
         lt_sflight  TYPE TABLE OF ty_sflight,
         lt_sflight2 TYPE TABLE OF ty_sflight.

* First select all the concerning fields
  SELECT carrid, connid, price, fldate
  FROM sflight
  ORDER BY price
  INTO TABLE @lt_sflight.

  cl_demo_output=>display( lt_sflight ).

  LOOP AT lt_sflight INTO ls_sflight.
    ls_sflight-carrid = 'SV'.
    ls_sflight-connid = 2016.
    ls_sflight-price = 2018.
    ls_sflight-fldate = '20160216'.

    MODIFY lt_sflight FROM ls_sflight.

  ENDLOOP.

  cl_demo_output=>display( lt_sflight ).

ENDFORM.

*&---------------------------------------------------------------------*
*& Form example_5
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM example_5 .

* In this example, I will change the price as 2018, if the carrid is LH  without using IF statement

* create model, structure
  TYPES : BEGIN OF ty_sflight,
            carrid TYPE sflight-carrid,
            connid TYPE sflight-connid,
            price  TYPE sflight-price,
            fldate TYPE sflight-fldate,
          END OF ty_sflight.

* Declare internal table and structure
  DATA : ls_sflight  TYPE ty_sflight,
         lt_sflight  TYPE TABLE OF ty_sflight,
         lt_sflight2 TYPE TABLE OF ty_sflight.

* First select all the concerning fields
  SELECT carrid, connid, price, fldate
  FROM sflight
  ORDER BY price
  INTO TABLE @lt_sflight.

  cl_demo_output=>display( lt_sflight ).


  LOOP AT lt_sflight INTO ls_sflight WHERE carrid = 'LH'.
    ls_sflight-price = 0.
    MODIFY lt_sflight FROM ls_sflight.
  ENDLOOP.

  cl_demo_output=>display( lt_sflight ).

ENDFORM.

*&---------------------------------------------------------------------*
*& Form example_6
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM example_6 .

* In this example, I will use IF statement to do modification
* if carrid is LH and connid is 2402, I will change price as 1984 and carrid as GC

  TYPES : BEGIN OF ty_sflight,
            carrid TYPE sflight-carrid,
            connid TYPE sflight-connid,
            price  TYPE sflight-price,
            fldate TYPE sflight-fldate,
          END OF ty_sflight.

  DATA : lt_sflight TYPE TABLE OF ty_sflight,
         ls_sflight TYPE ty_sflight.

  SELECT carrid, connid, price, fldate FROM sflight
    ORDER BY price
    INTO TABLE @lt_sflight.

  cl_demo_output=>display( lt_sflight ).

  LOOP AT lt_sflight INTO ls_sflight.
    IF ls_sflight-carrid = 'LH' AND ls_sflight-connid = 2402.
      ls_sflight-carrid = 'GC'.
      ls_sflight-price = 1984.
      MODIFY lt_sflight FROM ls_sflight.

    ELSEIF ls_sflight-carrid = 'LH' AND ls_sflight-connid = 2407.
      ls_sflight-carrid = 'OC'.
      ls_sflight-price = 1981.
      MODIFY lt_sflight FROM ls_sflight.
    ELSE.
      ls_sflight-carrid = 'OO'.
      ls_sflight-price = 0000.
      ls_sflight-connid = 0000.
      MODIFY lt_sflight FROM ls_sflight.
    ENDIF.
  ENDLOOP.

  cl_demo_output=>display( lt_sflight ).


ENDFORM.

*&---------------------------------------------------------------------*
*& Form example_7
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM example_7 .

* In this example I will delete a row from table

  TYPES : BEGIN OF ty_sflight,
            carrid TYPE sflight-carrid,
            connid TYPE sflight-connid,
            price  TYPE sflight-price,
            fldate TYPE sflight-fldate,
          END OF ty_sflight.

  DATA : lt_sflight TYPE TABLE OF ty_sflight,
         ls_sflight TYPE ty_sflight,
         lv_index   TYPE i VALUE 1.

  SELECT carrid, connid, price, fldate FROM sflight
    ORDER BY price
    INTO TABLE @lt_sflight.

  cl_demo_output=>display( lt_sflight ).

* first modify the first row to undestand easily, whether the delete is successful or not

  LOOP AT lt_sflight INTO ls_sflight.
    IF ls_sflight-fldate = '20191114'.
      ls_sflight-carrid = 'GC'.
      ls_sflight-price = 1984.
      MODIFY lt_sflight FROM ls_sflight.

    ELSE.
      ls_sflight-carrid = 'OO'.
      ls_sflight-price = 0000.
      ls_sflight-connid = 0000.
      MODIFY lt_sflight FROM ls_sflight.
    ENDIF.
  ENDLOOP.
  cl_demo_output=>display( lt_sflight ).

* You can also see the number of the rows before delete after delete

  DATA : v_lines TYPE i. "declare variable
  DESCRIBE TABLE lt_sflight LINES v_lines. "get no of rows
  WRITE:/  'Number of rows before delete : ' && v_lines. "display no of rows


* Now, you did different first row from the others, and you can see that you delete or not.

  DELETE lt_sflight INDEX 1.

  cl_demo_output=>display( lt_sflight ).


  DESCRIBE TABLE lt_sflight LINES v_lines. "get no of rows
  WRITE:/ 'Number of rows after delete : ' && v_lines. "display no of rows

ENDFORM.

*&---------------------------------------------------------------------*
*& Form example_8
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM example_8 .

* In this example I will delete a specific area of the rows using index

  TYPES : BEGIN OF ty_sflight,
            carrid TYPE sflight-carrid,
            connid TYPE sflight-connid,
            price  TYPE sflight-price,
            fldate TYPE sflight-fldate,
          END OF ty_sflight.

  DATA : lt_sflight TYPE TABLE OF ty_sflight,
         ls_sflight TYPE ty_sflight,
         lv_index   TYPE i VALUE 1.

  SELECT carrid, connid, price, fldate FROM sflight
    ORDER BY price
    INTO TABLE @lt_sflight.

  cl_demo_output=>display( lt_sflight ).

* first modify the rows from 1 to 6 to undestand easily, whether the delete is successful or not

  LOOP AT lt_sflight INTO ls_sflight FROM 1 TO 10.

    ls_sflight-carrid = 'GC'.
    ls_sflight-price = 2016.
    ls_sflight-connid = 2018.
    ls_sflight-fldate = '19840915'.
    MODIFY lt_sflight FROM ls_sflight.

  ENDLOOP.
  cl_demo_output=>display( lt_sflight ).

* You can also see the number of the rows before delete after delete

  DATA : v_lines TYPE i. "declare variable
  DESCRIBE TABLE lt_sflight LINES v_lines. "get no of rows
  WRITE:/  'Number of rows before delete : ' && v_lines. "display no of rows


* Now, you did different first row from the others, and you can see that you delete or not.

  DELETE lt_sflight FROM 1 TO 7.

  cl_demo_output=>display( lt_sflight ).


  DESCRIBE TABLE lt_sflight LINES v_lines. "get no of rows
  WRITE:/ 'Number of rows after delete : ' && v_lines. "display no of rows

ENDFORM.

*&---------------------------------------------------------------------*
*& Form example_9
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM example_9 .

* write title of the columns, here 05, 15, 25 is spaces
* uline create underline
* new carrid, after each car id changes, we will see the title of new carrid.

  TYPES : BEGIN OF ty_sflight,
            carrid TYPE sflight-carrid,
            connid TYPE sflight-connid,
            price  TYPE sflight-price,
            fldate TYPE sflight-fldate,
          END OF ty_sflight.

  DATA : lt_sflight TYPE TABLE OF ty_sflight,
         ls_sflight TYPE ty_sflight,
         lv_index   TYPE i VALUE 1.

  SELECT carrid, connid, price, fldate FROM sflight
    ORDER BY price
    INTO TABLE @lt_sflight.

  cl_demo_output=>display( lt_sflight ).


  LOOP AT lt_sflight INTO ls_sflight.

* AT FIRST is used only in LOOP

    AT FIRST.
* They are titles

      WRITE AT :  /05 'CARRID',
                    20 'CONNID',
                    38 'FLDATE',
                    58 'PRICE'.
* sy-uline is underline
      WRITE sy-uline.
    ENDAT.

* When a new carrid starts, it will write a title
    AT NEW carrid.
      WRITE AT: /05 'NEW CARRID'.

    ENDAT.

    WRITE AT : /05 ls_sflight-carrid,
                 20 ls_sflight-connid,
                 35 ls_sflight-fldate,
                 45 ls_sflight-price.

    AT LAST.
      WRITE sy-uline.
      WRITE 'END OF REPORT | GULCAN COSKUN'.
    ENDAT.
  ENDLOOP.


ENDFORM.