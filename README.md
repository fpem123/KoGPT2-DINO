# KoGPT2-DINO
[![Run on Ainize](https://ainize.ai/images/run_on_ainize_button.svg)](https://ainize.web.app/redirect?git_repo=https://github.com/fpem123/KoGPT2-DINO)

- KoGPT2와 Datasets from Instructions (DINO 🦕)를 이용하여 데이터를 생성하는 어플리케이션입니다.
- 학습된 모형과 Config 등에 의해 성능은 달라질 수 있습니다.

## 예시

Input:
- 문장: GPT-2는 주어진 텍스트의 다음 단어를 잘 예측할 수 있도록 학습된 언어모델입니다.

Output (파인튜닝 없이 생성):
- 동일 의미: "GPT-2는 주어진 텍스트의 다음 단어를 정확히 예측할 수 있도록 학습된 언어모델입니다."
- 유사 의미: "GPT-2는 텍스트의 다음 단어를 예측하도록 고안된 언어모델입니다."
- 다른 주제: "GPT-2의 첫 문장을 잘 예측할 수 있게끔 연습하십시오."


References:
- https://github.com/SKT-AI/KoGPT2
- https://github.com/timoschick/dino

--------------------------------

## HOT TO USE


#### Post parameter

    text: The base of generated text.

#### Output format

    {
        0: {
            label: generated text type number,
            text_a: base text string,
            text_b: generated text string
            }
        ...
    }

### With CLI

#### Input example

* text: GPT-2는 주어진 텍스트의 다음 단어를 잘 예측할 수 있도록 학습된 언어모델입니다.


    curl -X POST "https://main-ko-gpt2-dino-fpem123.endpoint.ainize.ai/gen" -H "accept: application/json" -H "Content-Type: multipart/form-data" -F "text=GPT-2는 주어진 텍스트의 다음 단어를 잘 예측할 수 있도록 학습된 언어모델입니다."


#### Output example

    {
      "0": {
        "label": "2",
        "text_a": "GPT-2는 주어진 텍스트의 다음 단어를 잘 예측할 수 있도록 학습된 언어모델입니다.",
        "text_b": "GPT-2는 텍스트 텍스트 텍스트 텍스트의 다음 단어를 잘 예측할 수 있도록 학습된 언어모델입니다."
      },
      "1": {
        "label": "0",
        "text_a": "GPT-2는 주어진 텍스트의 다음 단어를 잘 예측할 수 있도록 학습된 언어모델입니다.",
        "text_b": "GPT-2는 그 문장의 마지막 문장을 잘 예측할 수 있게끔 유도하고 있습니다."
      }
    }


### With API

API page: [Ainize](https://ainize.ai/fpem123/KoGPT2-DINO?branch=main)

### With Demo

Demo page: [End-point](https://main-ko-gpt2-dino-fpem123.endpoint.ainize.ai/)

--------------------------------

### Prepare

```sh
git clone https://github.com/soeque1/KoGPT2-DINO.git --recursive
cd KoGPT2-DINO
```

### Input

```sh
cat test_input.txt
```

> GPT-2는 주어진 텍스트의 다음 단어를 잘 예측할 수 있도록 학습된 언어모델입니다.

### Config

```sh
cat task_specs/para-ko.json
pip install -r requirements.txt
```

```json
{
    "task_name": "para-ko",
    "labels": {
      "2": {
        "instruction": "과제 : 동일한 의미의 두 문장을 작성하세요.\n문장 1: \"<X1>\"\n문장 2: \"",
        "counter_labels": []
      },
      "1": {
        "instruction": "과제 : 비슷한 의미의 두 문장을 작성하세요.\n문장 1: \"<X1>\"\n문장 2: \"",
        "counter_labels": [
          "2"
        ]
      },
      "0": {
        "instruction": "과제 : 완전히 다른 주제에 관하여 두 문장을 작성하세요.\n문장 1: \"<X1>\"\n문장 2: \"",
        "counter_labels": [
          "2",
          "1"
        ]
      }
    }
  }
```

### Run

- ONLY CPU
```sh
python dino/dino.py \
 --output_dir test_out \
 --model_name skt/kogpt2-base-v2 \
 --task_file task_specs/para-ko.json \
 --input_file test_input.txt \
 --input_file_type plain \
 --max_output_length 128 \
 --top_p 0.9 \
 --top_k 5 \
 --decay_constant 100 \
 --remove_identical_pairs \
 --num_entries_per_input_and_label 1 \
 --no_cuda
```

- GPU
```
python dino/dino.py \
 --output_dir test_out \
 --model_name skt/kogpt2-base-v2 \
 --task_file task_specs/para-ko.json \
 --input_file test_input.txt \
 --input_file_type plain \
 --max_output_length 128 \
 --top_p 0.9 \
 --top_k 5 \
 --decay_constant 100 \
 --remove_identical_pairs \
 --num_entries_per_input_and_label 1
```

- DOCKER (GPU)
```
docker run \
  --gpus 1 \
  -v $PWD:/workspace \
  nvcr.io/nvidia/pytorch:20.12-py3 \
  bash -c "
  pip install -r requirements.txt &&
  python dino/dino.py \
  --output_dir test_out \
  --model_name skt/kogpt2-base-v2 \
  --task_file task_specs/para-ko.json \
  --input_file test_input.txt \
  --input_file_type plain \
  --max_output_length 128 \
  --top_p 0.9 \
  --top_k 5 \
  --decay_constant 100 \
  --remove_identical_pairs \
  --num_entries_per_input_and_label 1"
```

### Results

```sh
cat test_out/para-ko-dataset.jsonl
```

```json
# 동일 의미 문장
{
  "text_a": "GPT-2는 주어진 텍스트의 다음 단어를 잘 예측할 수 있도록 학습된 언어모델입니다.",
  "text_b": "GPT-2는 주어진 텍스트의 다음 단어를 정확히 예측할 수 있도록 학습된 언어모델입니다.",
  "label": "2"
}

# 유사 의미 문장
{
  "text_a": "GPT-2는 주어진 텍스트의 다음 단어를 잘 예측할 수 있도록 학습된 언어모델입니다.",
  "text_b": "GPT-2는 텍스트의 다음 단어를 예측하도록 고안된 언어모델입니다.",
  "label": "1"
}

# 다른 주제 문장
{
  "text_a": "GPT-2는 주어진 텍스트의 다음 단어를 잘 예측할 수 있도록 학습된 언어모델입니다.",
  "text_b": "GPT-2의 첫 문장을 잘 예측할 수 있게끔 연습하십시오.",
  "label": "0"
}
```