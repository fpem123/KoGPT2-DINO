# KoGPT2-DINO
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

## Prepare

```sh
git clone https://github.com/soeque1/KoGPT2-DINO.git --recursive
cd KoGPT2-DINO
```

## Input

```sh
cat test_input.txt
```

> GPT-2는 주어진 텍스트의 다음 단어를 잘 예측할 수 있도록 학습된 언어모델입니다.

## Config

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

## Run

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
 --num_entries_per_input_and_label 1
```

## Results

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