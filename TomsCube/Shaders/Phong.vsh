//
//  Boxes.vsh
//  TomsCube
//
//  Created by Thomas Bouldin on 3/12/12.
//  Copyright (c) 2012 Espressobytes. All rights reserved.
//

attribute vec4 position;
attribute vec3 normal;
attribute vec3 color;

varying lowp vec3 colorVarying;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform vec3 ambientLight;
//uniform vec3 lightPosition;

void main()
{
  vec3 eyeNormal = normalize(normalMatrix * normal);
  vec3 lightPosition = vec3(4.0, 4.0, 5.0);
    
  float nDotVP = //max(0.0, dot(eyeNormal, normalize(lightPosition)));
      abs(dot(eyeNormal, normalize(lightPosition)));
                 
  colorVarying = color * nDotVP + ambientLight;
  
  gl_Position = modelViewProjectionMatrix * position;
}
