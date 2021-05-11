FROM python

RUN apt-get update && \
    apt-get install -y && \
    apt-get install -y apt-utils wget

RUN pip install --upgrade pip
RUN pip install transformers \
    torch \
    tokenizer \
    waitress \
    tqdm

CMD ['git', 'clone', 'https://github.com/fpem123/dino.git', '/dino']

RUN mkdir -p /app
WORKDIR /app
COPY . .

EXPOSE 80

CMD ['python dino/app.py',  \
     '--output_dir test_out',   \
     '--model_name skt/kogpt2-base-v2', \
     '--task_file task_specs/para-ko.json', \
     '--input_file test_input.txt', \
     '--input_file_type plain', \
     '--max_output_length 128', \
     '--top_p 0.9', \
     '--top_k 5',   \
     '--decay_constant 100',    \
     '--remove_identical_pairs',    \
     '--num_entries_per_input_and_label 1']