

**************************************************************************************************;
*   	   		  PROGRAM: SCH_format.sas                                                        *;
*   	  	  	  NOTE: This program provides formatted values for the categorical            	 *;
*                   	variables in the CCD SCH file.                                        	 *;
*   		  	  PROVIDED BY: National Center for Education Statistics                          *;
*   		      LAST UPDATED: August 17, 2017                                                  *;
**************************************************************************************************;

PROC FORMAT;

  VALUE $fipsf
	'01'='Alabama'        	 '02'='Alaska'          '04'='Arizona' 		   '05'='Arkansas'          
    '06'='California'     	 '08'='Colorado'        '09'='Connecticut'     '10'='Delaware'         
    '11'='District of Columbia'                     '12'='Florida'         '13'='Georgia' 	         
    '15'='Hawaii'         	 '16'='Idaho'           '17'='Illinois'	       '18'='Indiana'       
    '19'='Iowa'           	 '20'='Kansas'          '21'='Kentucky'        '22'='Louisiana'     
    '23'='Maine'          	 '24'='Maryland'        '25'='Massachusetts'   '26'='Michigan'      
    '27'='Minnesota'      	 '28'='Mississippi'     '29'='Missouri'        '30'='Montana'       
    '31'='Nebraska'       	 '32'='Nevada'          '33'='New Hampshire'   '34'='New Jersey'    
    '35'='New Mexico'      	 '36'='New York'        '37'='North Carolina'  '38'='North Dakota'  
    '39'='Ohio'           	 '40'='Oklahoma'        '41'='Oregon'          '42'='Pennsylvania'  
    '43'='Puerto Rico'    	 '44'='Rhode Island'    '45'='South Carolina'  '46'='South Dakota'  
    '47'='Tennessee'      	 '48'='Texas'           '49'='Utah'            '50'='Vermont'       
    '51'='Virginia'       	 '53'='Washington'      '54'='West Virginia'   '55'='Wisconsin'      
    '56'='Wyoming'        	 '59'='Bureau of Indian Education'		       '60'='American Samoa'
	'63'='Department of Defense Education Activity' '66'='Guam'            '69'='Northern Marianas' 
    '72'='Puerto Rico'       '78'='U.S. Virgin Islands' 
	'M'='Missing'            'N'='Not Applicable';

  VALUE $stabrf
	'AL'='Alabama'		 'AK'='Alaska'			'AZ'='Arizona'		 'AR'='Arkansas'	'CA'='California'
	'CO'='Colorado'		 'CT'='Connecticut'		'DE'='Delaware'		 'DC'='District of Columbia'
	'FL'='Florida'		 'GA'='Georgia'			'HI'='Hawaii'		 'ID'='Idaho'	    'IL'='Illinois'
	'IN'='Indiana'		 'IA'='Iowa'			'KS'='Kansas'		 'KY'='Kentucky'	'LA'='Louisiana'
	'ME'='Maine'		 'MD'='Maryland'		'MA'='Massachusetts' 'MI'='Michigan'    'MN'='Minnesota'
	'MS'='Mississippi'	 'MO'='Missouri'		'MT'='Montana'		 'NE'='Nebraska'	'NV'='Nevada'
	'NH'='New Hampshire' 'NJ'='New Jersey'		'NM'='New Mexico'	 'NY'='New York'	'NC'='North Carolina'
	'ND'='North Dakota'	 'OH'='Ohio'			'OK'='Oklahoma'	     'OR'='Oregon'      'PA'='Pennsylvania'
	'RI'='Rhode Island'  'SC'='South Carolina'  'SD'='South Dakota'  'TN'='Tennessee'   'TX'='Texas'
	'UT'='Utah'			 'VT'='Vermont'			'VA'='Virginia'		 'WA'='Washington'	'WV'='West Virginia'
	'WI'='Wisconsin'	 'WY'='Wyoming'
	'DD'='Department of Defense Education Activity'
	'BI'='Bureau of Indian Education'
	'AS'='American Samoa'
	'GU'='Guam'
	'MP'='Northern Marianas'
	'PR'='Puerto Rico'
	'VI'='U.S. Virgin Islands'
	'AS'='American Samoa'
	'MP'='Northern Marianas'
	'M'='Missing'  'N'='Not Applicable';

 VALUE $stypef
 	'1' = 'Regular School'
	'2' = 'Special Education School'
	'3' = 'Vocational Education School'
	'4' = 'Alternative Education School'
	'5' = 'Reportable program'
 	'M'  ='Missing'
	'N'  ='Not applicable';

  VALUE $Gslof
	'01' ='1st grade students'
	'02' ='2nd grade students'
	'03' ='3rd grade students'
	'04' ='4th grade students'
	'05' ='5th grade students'
	'06' ='6th grade students'
	'07' ='7th grade students'
	'08' ='8th grade students'
	'09' ='9th grade students'
	'10' ='10th grade students'
	'11' ='11th grade students'
	'12' ='12th grade students'
	'13' ='13th grade students'
	'AE' ='Total adult education students'
	'KG' ='Kindergarten students'
	'PK' ='Prekindergarten students'
	'UG' ='Students in ungraded classes'
	'M'  ='Missing'
	'N'  ='Not applicable';

  VALUE $Gshif
	'01' ='1st grade students'
	'02' ='2nd grade students'
	'03' ='3rd grade students'
	'04' ='4th grade students'
	'05' ='5th grade students'
	'06' ='6th grade students'
	'07' ='7th grade students'
	'08' ='8th grade students'
	'09' ='9th grade students'
	'10' ='10th grade students'
	'11' ='11th grade students'
	'12' ='12th grade students'
	'13' ='13th grade students'
	'AE' ='Total adult education students'
	'KG' ='Kindergarten students'
	'PK' ='Prekindergarten students'
	'UG' ='Students in ungraded classes'
	'M'  ='Missing'
	'N'  ='Not applicable';

  VALUE $levelf
	'1' = 'Primary (low grade = PK through 03; high grade = PK through 08)'
	'2' = 'Middle (low grade = 04 through 07; high grade = 04 through 09)'
	'3' = 'High (low grade = 07 through 12; high grade = 12 only)'
	'4' = 'Other (any other configuration not falling within the above three categories, including ungraded)'
	'N'  ='Not applicable';

  VALUE $Systaf  
	'1'='Open'
	'2'='Closed'
	'3'='New'
	'4'='Added'
	'5'='Changed Agency'
	'6'='Inactive'
	'7'='Future School'
	'8'='Reopened';

   VALUE $Upstaf  
	'1'='Open'
	'2'='Closed'
	'3'='New'
	'4'='Added'
	'5'='Changed Agency'
	'6'='Inactive'
	'7'='Future School'
	'8'='Reopened';

  VALUE $igoffrf
	'A'  ='Adjustment'
	'R'  ='As reported by the state';

  VALUE $TitleIstaf
	'1'='Title I targeted assistance eligible school-No program'
	'2'='Title I targeted assistance school'
	'3'='Title I schoolwide eligible-Title I targeted assistance program'
	'4'='Title I schoolwide eligible school-No program'
	'5'='Title I schoolwide school'
	'6'='Not a Title I school'
	'-9'='Suppressed'
	'M'='Missing';

  VALUE $TitleIf
	'Yes'     = 'Yes'
	'No'      = 'No'
	'Missing' = 'Missing'
	'Not Applicable'   = 'Not Applicable'
    '-9'='Suppressed';

   VALUE $StitlIf
	'Yes'     = 'Yes'
	'No'      = 'No'
	'Missing' = 'Missing'
	'Not Applicable'   = 'Not Applicable'
    '-9'='Suppressed';

  VALUE $NSLPSTATUSf
	'CEO'='Yes, under Community Eligibility Option (CEO)'
	'NO'='No'
	'NP'='Yes, participating without using any Provision or the CEO'
	'P1'='Yes, under Provision 1'
	'P2'='Yes, under Provision 2'
	'P3'='Yes, under Provision 3'
    'M'='MISSING';

run;


