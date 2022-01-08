FROM jupyter/minimal-notebook

MAINTAINER Jan Losinski losinski@wh2.tu-dresden.de

USER root
RUN apt-get update && \
	apt-get install -yq --no-install-recommends \
		texlive-latex-recommended \
		texlive-lang-english \
		texlive-lang-european \
		texlive-lang-german \
		texlive-pstricks \
		openssh-client \
		git \
		pandoc \
		tmux \
		vim \
	&& \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* 

USER $NB_UID


RUN \
	mamba install --quiet --yes \
		jupyterlab-git \
		jupyterlab-latex \
		&& \
	pip install --no-cache-dir \
		jupyterlab_latex \
		dockerspawner \
		oauthenticator \
		cufflinks \
		requests \
	        arrow \
		dateutils \
	&& \
	mamba clean --all -f -y && \
    	npm cache clean --force && \
    	jupyter notebook --generate-config && \
    	jupyter lab clean && \
    	rm -rf "/home/${NB_USER}/.cache/yarn" && \
    	fix-permissions "${CONDA_DIR}" && \
    	fix-permissions "/home/${NB_USER}"
	

RUN ln -s /home/$NB_USER/work/.ssh /home/$NB_USER/.ssh && \
	ln -s /home/$NB_USER/work/.gitconfig /home/$NB_USER/.gitconfig && \
	ln -s /home/$NB_USER/work/.tmux.conf /home/$NB_USER/.tmux.conf && \
	ln -s /home/$NB_USER/work/.tmux-line.conf /home/$NB_USER/.tmux-line.conf && \
	ln -s /home/$NB_USER/work/.gnupg /home/$NB_USER/.gnupg && \
	ln -s /home/$NB_USER/work/.vim /home/$NB_USER/.vim && \
	ln -s /home/$NB_USER/work/.vimrc /home/$NB_USER/.vimrc
	ln -s /home/$NB_USER/work/.pandoc /home/$NB_USER/.pandoc
		
ADD jupyterhub_config.py /home/$NB_USER/.jupyter/
ADD jupyter_notebook_config.py /home/$NB_USER/.jupyter/

