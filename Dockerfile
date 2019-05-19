FROM jupyter/scipy-notebook

MAINTAINER Jan Losinski losinski@wh2.tu-dresden.de

RUN \
	conda install --quiet --yes -c conda-forge \
		jupyterhub \
		ipysheet \
		jupyterlab-git \
	&& \
	conda install --quiet --yes -c plotly \
		dash \
		plotly \
		jupyterlab-dash=0.1.0a2 \
		&& \
	pip install \
		jupyterlab_latex \
		dockerspawner \
		git+https://github.com/janLo/oauthenticator@generic-nested-userdata \
                oauthenticator \
		cufflinks \
	&& \
	jupyter labextension install @jupyterlab/latex &&\
	jupyter labextension install ipysheet && \
	jupyter labextension install @jupyterlab/git && \
	jupyter labextension install jupyterlab-dash@0.1.0-alpha.2 && \
	jupyter labextension install @jupyterlab/plotly-extension && \
        jupyter labextension install @jupyterlab/hub-extension && \
	jupyter serverextension enable --py jupyterlab_git && \
	conda clean --all -f -y && \
	npm cache clean --force && \
	rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
	rm -rf /home/$NB_USER/.cache/yarn && \
	rm -rf /home/$NB_USER/.node-gyp && \
	fix-permissions $CONDA_DIR && \
	fix-permissions /home/$NB_USER

USER root
RUN apt-get update && \
	apt-get install -yq --no-install-recommends \
		texlive-latex-recommended \
		texlive-lang-english \
		texlive-lang-european \
		texlive-lang-german \
		texlive-pstricks \
	&& \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* &&\
	groupadd docker --gid 131 && \
	adduser $NB_USER docker

USER $NB_UID

RUN pip install \
	requests \
	arrow \
	dateutils \
	webdavclient3 \
	webdavclient
		
ADD jupyterhub_config.py /home/$NB_USER/.jupyter/
ADD jupyter_notebook_config.py /home/$NB_USER/.jupyter/

