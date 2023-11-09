FROM quay.io/jupyter/datascience-notebook:2023-10-23

RUN echo "options(repos = c(CRAN = \"https://packagemanager.posit.co/cran/__linux__/jammy/latest\"))" >>"/home/jovyan/.Rprofile" \
    && echo "options(BioC_mirror = \"https://packagemanager.posit.co/bioconductor\")" >>"/home/jovyan/.Rprofile" \
    && echo "options(BIOCONDUCTOR_CONFIG_FILE = \"https://packagemanager.posit.co/bioconductor/config.yaml\")" >>"/home/jovyan/.Rprofile" \
    && cat "/home/jovyan/.Rprofile" \
    # install GOplot, clusterProfiler
    && R -e "install.packages('BiocManager')" \
    && R -e "BiocManager::install(c('GOplot', 'clusterProfiler', 'org.Hs.eg.db', 'limma', 'edgeR', 'tidyverse', 'DESeq2'))" \
    && R -e "BiocManager::install(c('pheatmap', 'RColorBrewer'))" \
    && rm -rf /tmp/*
RUN mamba install --yes 'udunits' -c conda-forge && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}" && \
    R -e "install.packages(c('udunits2', 'units'))"
USER root
RUN apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:ubuntugis/ppa && \
    apt-get update && sudo apt-get install -y gdal-bin libgdal-dev
RUN cp /opt/conda/lib/R/etc/Makeconf /opt/conda/lib/R/etc/Makeconf.bak && \
    sed -i 's/CC = x86_64-conda-linux-gnu-cc/CC = gcc/g' /opt/conda/lib/R/etc/Makeconf && \
    sed -i 's/CXX = x86_64-conda-linux-gnu-c++ -std=gnu++17/CXX = g++/g' /opt/conda/lib/R/etc/Makeconf
USER jovyan
RUN R -e "install.packages(c('sf','ggVennDiagram'))"
USER root
RUN cp /opt/conda/lib/R/etc/Makeconf.bak /opt/conda/lib/R/etc/Makeconf