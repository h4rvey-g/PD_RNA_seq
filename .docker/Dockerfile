FROM quay.io/jupyter/datascience-notebook:2023-10-23

# USER root
RUN echo "options(repos = c(CRAN = \"https://packagemanager.posit.co/cran/__linux__/jammy/latest\"))" >>"/home/jovyan/.Rprofile" \
    && echo "options(BioC_mirror = \"https://packagemanager.posit.co/bioconductor\")" >>"/home/jovyan/.Rprofile" \
    && echo "options(BIOCONDUCTOR_CONFIG_FILE = \"https://packagemanager.posit.co/bioconductor/config.yaml\")" >>"/home/jovyan/.Rprofile" \
    && cat "/home/jovyan/.Rprofile" \
    # install GOplot, clusterProfiler
    && R -e "install.packages('BiocManager')" \
    && R -e "BiocManager::install(c('GOplot', 'clusterProfiler', 'org.Hs.eg.db', 'limma', 'edgeR', 'tidyverse', 'DESeq2'))" \
    && rm -rf /tmp/* \