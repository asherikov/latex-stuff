NAME=${DIRNAME}
TEXNAME=paper


DVIPS_ARG=-Pdownload35 -Ppdf -G0 -tletter
PSPDF_ARG=-dCompatibilityLevel=1.4 \
		  -dPDFSETTINGS=/printer \
		  -dMAxSubsetPct=100 \
		  -dSubsetFonts=true \
		  -dEmbedAllFonts=true \
		  -sPAPERSIZE=letter \
		  -dUseCIEColor

WRKDIR=tmp
ENV=env TEXINPUTS=".:${PWD}/:${PWD}/Styles/:${PWD}/Figures/:" BSTINPUTS="${PWD}:${PWD}/Styles/:" BIBINPUTS="${PWD}:${PWD}/Styles/:"

# compile PDF
paper:
	mkdir -p ${WRKDIR}
	cd ${WRKDIR}; ${ENV} latex ${TEXNAME}.tex
	cd ${WRKDIR}; ${ENV} bibtex ${TEXNAME}
	cd ${WRKDIR}; ${ENV} latex ${TEXNAME}.tex
	cd ${WRKDIR}; ${ENV} latex ${TEXNAME}.tex
	cd ${WRKDIR}; ${ENV} dvips ${DVIPS_ARG} ${TEXNAME}
	cd ${WRKDIR}; ${ENV} ps2pdf ${PSPDF_ARG} ${TEXNAME}.ps
	mv ${WRKDIR}/${TEXNAME}.pdf ${NAME}.pdf


# convert PDF from letter to A4 paper format for printing
a4: paper
	pdfjam ${NAME}.pdf --a4paper --outfile ${NAME}_a4.pdf


clean:
	rm -f ${WRKDIR}/*
#	rm -Rf *.aux *.log *.out ${TEXNAME}.dvi ${TEXNAME}.ps ${TEXNAME}.bbl ${TEXNAME}.blg ${TEXNAME}.pfg


spell:
	hunspell -t ${TEXNAME}.tex


fclean: clean
	rm -Rf ${TEXNAME}.pdf ${NAME}.pdf ${NAME}_a4.pdf
