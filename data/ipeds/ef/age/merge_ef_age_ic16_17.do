
cd "C:\Users\ozanj\Documents\rclass\data\ipeds\ef\age"

*open EF by age variable
use ef16-17_age_b.dta, clear

bysort unitid lstudy efbage: assert _N==1 // TRUE

capture noisily bysort unitid lstudy line: assert _N==1 // FALSE
drop line
drop x*

bysort unitid lstudy efbage: assert _N==1 // TRUE

tab efbage, m

*merge IC data
merge m:1 unitid using ic16-17, ///
	gen(merge_age_ic) keep(master match) ///
	keepusing(unitid fullname stabbr sector iclevel control hloffer locale)
	
numlabel, add

save ef_age_ic_fall_2016, replace
