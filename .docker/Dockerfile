FROM quay.io/jupyter/datascience-notebook:2023-10-23

RUN mamba install --yes 'GSEApy' -c bioconda  && \
    pip install --no-cache-dir 'pyforest' && \
    mamba clean --all -f -y && \
    R -e "BiocManager::install(c('clusterProfiler', 'GOplot'))" && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"