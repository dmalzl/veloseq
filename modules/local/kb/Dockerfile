FROM continuumio/miniconda3:4.9.2 AS conda

COPY environment.yml .

RUN conda env create -f environment.yml && \
    conda clean -afy


FROM centos:latest

COPY --from=conda /opt/conda/envs/kb /opt/conda/envs/kb

ENV PATH=/opt/conda/envs/kb/bin:$PATH