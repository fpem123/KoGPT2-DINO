FROM pytorch/pytorch:1.6.0-cuda10.1-cudnn7-runtime

RUN apt-get update && \
    apt-get install -y && \
    apt-get install -y apt-utils wget && \
    apt-get install git -y

RUN pip install --upgrade pip
RUN pip install transformers \
    tokenizer \
    waitress \
    flask \
    tqdm

RUN mkdir -p /app
WORKDIR /app
COPY . .
RUN git clone https://github.com/fpem123/dino.git /app/dino

EXPOSE 80

CMD ["python", "dino/app.py",  \
     "--output_dir", "test_out",   \
     "--model_name", "skt/kogpt2-base-v2", \
     "--task_file", "task_specs/para-ko.json", \
     "--input_file", "test_input.txt", \
     "--input_file_type", "plain", \
     "--max_output_length", "128", \
     "--top_p", "0.9", \
     "--top_k", "5",   \
     "--decay_constant", "100",    \
     "--remove_identical_pairs",    \
     "--num_entries_per_input_and_label", "1"]
