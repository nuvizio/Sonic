import os
import argparse
from sonic import Sonic
pipe = Sonic(0)


parser = argparse.ArgumentParser()
parser.add_argument('image_path')
parser.add_argument('audio_path')
parser.add_argument('output_path')
parser.add_argument('--dynamic_scale', type=float, default=1.0)
parser.add_argument('--crop', action='store_true')
parser.add_argument('--seed', type=int, default=None)

args = parser.parse_args()

if not os.path.isfile(args.image_path):
    if not os.path.exists(args.image_path):
        parser.error(f'image_path not found: {args.image_path}')
    parser.error(f'image_path is not a file: {args.image_path}')

if not os.path.isfile(args.audio_path):
    if not os.path.exists(args.audio_path):
        parser.error(f'audio_path not found: {args.audio_path}')
    parser.error(f'audio_path is not a file: {args.audio_path}')


face_info = pipe.preprocess(args.image_path, expand_ratio=0.5)
print(face_info)
if face_info['face_num'] >= 0:
    if args.crop:
        crop_image_path = args.image_path + '.crop.png'
        pipe.crop_image(args.image_path, crop_image_path, face_info['crop_bbox'])
        args.image_path = crop_image_path
    os.makedirs(os.path.dirname(args.output_path), exist_ok=True)
    pipe.process(args.image_path, args.audio_path, args.output_path, min_resolution=512, inference_steps=25, dynamic_scale=args.dynamic_scale)
