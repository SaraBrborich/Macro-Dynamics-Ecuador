/* -----------------------------------------------------------------------------
ESTIMACIÓN DEMANDA DE DINERO ECUADOR 
--------------------------------------------------------------------------------
Sara Brborich
Emilio Touma
--------------------------------------------------------------------------------
This version:				Noviembre 2023
Years covered:				2001 - 2022
------------------------------------------------------------------------------*/

/* -----------------------------------------------------------------------------
--- INITIAL SETUP 
------------------------------------------------------------------------------*/
global desktop_sara = "C:\Users\slbrb\OneDrive - Universidad San Francisco de Quito\Escritorio\Universidades\USFQ\7mo Semestre\Política Monetaria y Fiscal\Proyecto Final\data"

cd "$desktop_sara"

use "..\data\dtas\DataFinal.dta", clear
tsset date

/* -----------------------------------------------------------------------------
--- Para estimar la demanda de dinero se usará el método de Engle y Granger de 2
	etapas. Los pasos a seguir son los siguientes: 
		1.1. chequear estacionariedad; 
		1.2. correr el modelo de largo plazo; 
		1.3. test de Granger sobre residuos; 
		1.4. estimar modelo de corto plazo a través de un Error Correction Model
------------------------------------------------------------------------------*/


/* -----------------------------------------------------------------------------
	1.1. ESTACIONARIEDAD
------------------------------------------------------------------------------*/
dfuller ln_M1, trend 
dfuller ln_gdp, trend 
dfuller ex_in_r, trend
* Resultado: El logaritmo de M1 y del PIB poseen no estacionariedad.

* --- En primeras diferencias
dfuller d.ln_M1
dfuller d.ln_gdp
dfuller d.ex_in_r
* Resultado: las variables exhiben estacionariedad.


/* -----------------------------------------------------------------------------
	1.2. REGRESIÓN DE LARGO PLAZO
------------------------------------------------------------------------------*/
reg ln_M1 ln_gdp ex_in_r trend
predict m1_largo_plazo, xb

/* -----------------------------------------------------------------------------
	1.3. TEST DE GRANGER SOBRE RESIDUOS
------------------------------------------------------------------------------*/
predict error, residuals
ssc install egranger
egranger ln_M1 ln_gdp ex_in_r trend
* Resultado: Las variables están cointegradas.


/* -----------------------------------------------------------------------------
	1.4. Modelo de corrección de errores
------------------------------------------------------------------------------*/
regress d.ln_M1 l.error d.ln_gdp d.ex_in_r 
predict m1_corto_plazo,xb


/* -----------------------------------------------------------------------------
	1.5. Cumulative sum test for parameter stability
------------------------------------------------------------------------------*/
estat sbcusum, level(99)

* No se rechaza la hipotesis nula de estabilidad estructural con 99% en las 
* bandas de confianza

/* -----------------------------------------------------------------------------
	1.6. Gráficos
------------------------------------------------------------------------------*/
tsline m1_largo_plazo
tsline m1_corto_plazo